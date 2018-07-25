defmodule NeoscanWeb.Api do
  @moduledoc """
    Main API for accessing data from the explorer.
    All data is provided through GET requests in `/api/main_net/v1`.
    Testnet isn't currently available.
  """

  @total_neo 100_000_000

  alias Neoscan.Blocks
  alias Neoscan.BlocksCache
  alias Neoscan.Counters
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.BlockGasGeneration

  def get_balance(address_hash) do
    balances = Addresses.get_balances(address_hash)
    unspent = Transactions.get_unspent_vouts(address_hash)

    balances =
      Enum.map(balances, fn %{name: name, asset: asset_hash, value: value} ->
        unspent2 =
          unspent
          |> Enum.filter(&(&1.asset_hash == asset_hash))
          |> Enum.map(
            &%{value: &1.value, txid: Base.encode16(&1.transaction_hash, case: :lower), n: &1.n}
          )

        %{
          unspent: unspent2,
          asset: name,
          amount: value
        }
      end)

    %{:address => Base58.encode(address_hash), :balance => balances}
  end

  # for the max(current_end_index, end_index), the end_index can be nil, it is expected that max(nil, 123) = nil
  defp get_vouts_range(
         [%{start_block_index: start_index, end_block_index: end_index} | _] = vouts
       ) do
    Enum.reduce(vouts, {start_index, end_index}, fn %{
                                                      start_block_index: start_index,
                                                      end_block_index: end_index
                                                    },
                                                    {current_start_index, current_end_index} ->
      {min(start_index, current_start_index), max(current_end_index, end_index)}
    end)
  end

  defp get_vouts_range(_), do: {0, 0}

  defp extract_sys_fees_in_range(sys_fees, start_index, end_index) do
    sys_fees
    |> Enum.filter(&(&1.index >= start_index and &1.index <= end_index))
    |> Enum.map(& &1.total_sys_fee)
    |> Enum.sum()
  end

  def get_unclaimed(address_hash) do
    vouts = Transactions.get_unclaimed_vouts(address_hash)
    current_index = Counters.count_blocks() - 1

    {start_index, end_index} = get_vouts_range(vouts)
    end_index = if is_nil(end_index), do: current_index, else: end_index
    sys_fees = BlocksCache.get_total_sys_fee(start_index, end_index - 1)

    unclaimed =
      Enum.reduce(vouts, 0, fn vout, acc ->
        value = round(vout.value)
        start_index = vout.start_block_index
        end_index = vout.end_block_index
        end_index = if is_nil(end_index), do: current_index, else: end_index

        generated =
          value * BlockGasGeneration.get_range_amount(start_index, end_index - 1) / @total_neo

        sys_fee =
          value * extract_sys_fees_in_range(sys_fees, start_index, end_index - 1) / @total_neo

        acc + sys_fee + generated
      end)

    %{:address => Base58.encode(address_hash), :unclaimed => unclaimed}
  end

  def get_claimed(address_hash) do
    claimed = Transactions.get_claimed_vouts(address_hash)

    claimed =
      claimed
      |> Enum.group_by(
        fn {_vout, claim} -> claim.transaction_hash end,
        fn {vout, _claim} -> vout end
      )
      |> Enum.sort_by(fn {_, [vout | _]} -> vout.start_block_index end)
      |> Enum.map(fn {_, vouts} ->
        %{txids: Enum.map(vouts, &Base.encode16(&1.transaction_hash, case: :lower))}
      end)

    %{:address => Base58.encode(address_hash), :claimed => claimed}
  end

  def get_claimable(address_hash) do
    vouts = Transactions.get_claimable_vouts(address_hash)

    {start_index, end_index} = get_vouts_range(vouts)
    sys_fees = BlocksCache.get_total_sys_fee(start_index, end_index - 1)

    claimable =
      Enum.map(vouts, fn vout ->
        value = round(vout.value)
        start_index = vout.start_block_index
        end_index = vout.end_block_index

        generated =
          value * BlockGasGeneration.get_range_amount(start_index, end_index - 1) / @total_neo

        sys_fee =
          value * extract_sys_fees_in_range(sys_fees, start_index, end_index - 1) / @total_neo

        unclaimed = sys_fee + generated

        %{
          value: value,
          unclaimed: unclaimed,
          sys_fee: sys_fee,
          start_height: start_index,
          end_height: end_index,
          generated: generated,
          n: vout.n,
          txid: Base.encode16(vout.transaction_hash, case: :lower)
        }
      end)

    unclaimed =
      claimable
      |> Enum.map(& &1.unclaimed)
      |> Enum.sum()

    %{address: Base58.encode(address_hash), claimable: claimable, unclaimed: unclaimed}
  end

  def get_block(hash_or_integer) do
    block = Blocks.get(hash_or_integer)
    unless is_nil(block), do: render_block(block)
  end

  defp render_block(block) do
    %{
      :hash => Base.encode16(block.hash, case: :lower),
      :confirmations => 1,
      :index => block.index,
      :merkleroot => Base.encode16(block.merkle_root, case: :lower),
      :nextblockhash => "",
      :nextconsensus => Base.encode16(block.next_consensus, case: :lower),
      :nonce => Base.encode16(block.nonce, case: :lower),
      :previousblockhash => "",
      :script => block.script,
      :size => block.size,
      :time => DateTime.to_unix(block.time),
      :version => block.version,
      :tx_count => block.tx_count,
      :transactions => Enum.map(block.transactions, &Base.encode16(&1, case: :lower)),
      :transfers => Enum.map(block.transfers, &Base.encode16(&1, case: :lower))
    }
  end

  def get_transaction(hash) do
    transaction = Transactions.get(hash)
    unless is_nil(transaction), do: render_transaction(transaction)
  end

  defp render_vout(vout) do
    %{
      value: vout.value,
      n: vout.n,
      asset: vout.asset.name,
      address_hash: Base58.encode(vout.address_hash),
      txid: Base.encode16(vout.transaction_hash, case: :lower)
    }
  end

  defp render_claim(vout) do
    %{
      value: vout.value,
      n: vout.n,
      asset: Base.encode16(vout.asset_hash, case: :lower),
      address_hash: Base58.encode(vout.address_hash),
      txid: Base.encode16(vout.transaction_hash, case: :lower)
    }
  end

  defp render_transaction(transaction) do
    %{
      :txid => Base.encode16(transaction.hash, case: :lower),
      :attributes => transaction.attributes,
      :net_fee => transaction.net_fee,
      :scripts => transaction.scripts,
      :size => transaction.size,
      :sys_fee => transaction.sys_fee,
      :type => Macro.camelize(transaction.type),
      :version => transaction.version,
      :vin => Enum.map(transaction.vins, &render_vout/1),
      :vouts => Enum.map(transaction.vouts, &render_vout/1),
      :time => DateTime.to_unix(transaction.block_time),
      :block_hash => Base.encode16(transaction.block_hash, case: :lower),
      :block_height => transaction.block_index,
      :nonce => nil,
      :claims => Enum.map(transaction.claims, &render_claim/1),
      :pubkey => nil,
      :asset => nil,
      :description => nil,
      :contract => nil
    }
  end

  defp render_last_transaction(transaction) do
    %{
      render_transaction(transaction)
      | vouts: Enum.map(transaction.vouts, &render_claim/1),
        vin: Enum.map(transaction.vins, &render_claim/1)
    }
  end

  def get_last_transactions_by_address(address_hash, page) do
    transactions = Transactions.get_for_address(address_hash, page)
    Enum.map(transactions, &render_last_transaction/1)
  end

  def get_all_nodes do
    NeoscanNode.get_data()
    |> Enum.map(fn {url, height} -> %{url: url, height: height} end)
  end

  def get_height do
    %{:height => Counters.count_blocks() - 1}
  end

  def get_address_abstracts(address_hash, page) do
    result = Addresses.get_transaction_abstracts(address_hash, page)
    %{result | entries: Enum.map(result.entries, &render_transaction_abstract/1)}
  end

  defp render_transaction_abstract(abt) do
    %{
      txid: Base.encode16(abt.transaction_hash, case: :lower),
      time: DateTime.to_unix(abt.block_time),
      asset: Base.encode16(abt.asset_hash, case: :lower),
      amount: render_amount(abt.value),
      address_to: render_transaction_abstract_address(abt.address_to, abt.transaction_hash),
      address_from: render_transaction_abstract_address(abt.address_from, abt.transaction_hash),
      block_height: abt.block_index
    }
  end

  defp render_amount(value) do
    value
    |> :erlang.float_to_binary([:compact, {:decimals, 10}])
    |> String.trim_trailing("0")
    |> String.trim_trailing(".")
  end

  defp render_transaction_abstract_address("burn", _), do: "burn"
  defp render_transaction_abstract_address("network_fees", _), do: "network_fees"
  defp render_transaction_abstract_address("fees", _), do: "fees"
  defp render_transaction_abstract_address("mint", _), do: "mint"
  defp render_transaction_abstract_address("claim", _), do: "claim"

  defp render_transaction_abstract_address("multi", transaction_hash),
    do: Base.encode16(transaction_hash, case: :lower)

  defp render_transaction_abstract_address(address_hash, _), do: Base58.encode(address_hash)

  def get_address_to_address_abstracts(address_hash1, address_hash2, page) do
    result = Addresses.get_address_to_address_abstracts(address_hash1, address_hash2, page)
    %{result | entries: Enum.map(result.entries, &render_transaction_abstract/1)}
  end
end
