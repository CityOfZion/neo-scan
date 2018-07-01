defmodule NeoscanWeb.Api do
  @moduledoc """
    Main API for accessing data from the explorer.
    All data is provided through GET requests in `/api/main_net/v1`.
    Testnet isn't currently available.
  """

  @total_neo 100_000_000

  alias Neoscan.Blocks
  alias Neoscan.Counters
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.BlockGasGeneration

  @doc """
  Returns the balance for an address from its `hash_string`
  ## Examples
      /api/main_net/v1/get_balance/{hash_string}
      {
        "balance": [
          {
            "asset": "name_string",
            "amount": float,
            "unspent": [
              {
                "txid": "tx_id_string",
                "value": float,
                "n": integer
              },
              ...
            ]
          }
          ...
        ],
        "address": "hash_string"
      }
  """
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
          asset: filter_name(name),
          amount: value
        }
      end)

    %{:address => Base58.encode(address_hash), :balance => balances}
  end

  @doc """
  Returns the unclaimed gas for an address from its `hash_string`
  ## Examples
      /api/main_net/v1/get_unclaimed/{hash_string}
      {
        "unclaimed": float,
        "address": "hash_string"
      }
  """
  def get_unclaimed(address_hash) do
    vouts = Transactions.get_unclaimed_vouts(address_hash)
    current_index = Counters.count_blocks() - 1

    unclaimed =
      Enum.reduce(vouts, 0, fn vout, acc ->
        value = round(vout.value)
        start_index = vout.start_block_index
        end_index = vout.end_block_index
        end_index = if is_nil(end_index), do: current_index, else: end_index

        generated =
          value * BlockGasGeneration.get_range_amount(start_index, end_index - 1) / @total_neo

        sys_fee = value * Blocks.get_sys_fees_in_range(start_index, end_index - 1) / @total_neo
        acc + sys_fee + generated
      end)

    %{:address => Base58.encode(address_hash), :unclaimed => unclaimed}
  end

  @doc """
  Returns the claimed transactions for an address, from its `hash_string`.
  ## Examples
      /api/main_net/v1/get_claimed/{hash_string}
      {
        "claimed": [
          {
            "txids": [
              "tx_id_string",
              "tx_id_string",
              "tx_id_string",
              ...
            ]
          },
          ...
        ],
        "address": "hash_string"
      }
  """
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

  @doc """
  Returns the AVAILABLE claimable transactions for an address, from its `hash_string`.
  ## Examples
      /api/main_net/v1/get_claimable/{hash_string}
      {
        "unclaimed": float,
        "claimable": [
          {
            "txid": "tx_id_string",
            "n": integer,
            "value": float,
            "unclaimed": float,
            "start_height": integer,
            "end_height": integer
          },
          ...
        ],
        "address": "hash_string"
      }
  """
  def get_claimable(address_hash) do
    vouts = Transactions.get_claimable_vouts(address_hash)

    claimable =
      Enum.map(vouts, fn vout ->
        value = round(vout.value)
        start_index = vout.start_block_index
        end_index = vout.end_block_index

        generated =
          value * BlockGasGeneration.get_range_amount(start_index, end_index - 1) / @total_neo

        sys_fee = value * Blocks.get_sys_fees_in_range(start_index, end_index - 1) / @total_neo
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

  @doc """
  Returns the address model from its `hash_string`
  ## Examples
      /api/main_net/v1/get_address_neon/{hash_string}
      {
        "txids": [
          {
            "txid": "tx_id_string",
            "balance": "balance_object_snapshot"
          },
          ...
        ],
        "claimed": [
          {
            "txids": [
              "tx_id_string",
              "tx_id_string",
              "tx_id_string",
              ...
            ],
            "asset": "name_string",
            "amount": "float",
          },
          ...
        ],
        "balance": [
          {
            "asset": "name_string",
            "amount": float,
            "unspent": [
              {
                "txid": "tx_id_string",
                "value": float,
                "n": integer
              },
              ..
            ]
          }
          ...
        ],
        "address": "hash_string"
      }
  """
  def get_address_neon(_hash) do
    %{
      :address => "not found",
      :balance => nil,
      :txids => nil,
      :claimed => nil
    }
  end

  @doc """
  Returns the block model from its `hash_string` or `height`
  ## Examples
      /api/main_net/v1/get_block/{hash_string}
      /api/main_net/v1/get_block/{height}
      {
        "version": integer,
        "tx_count": integer,
        "transactions": [
          "tx_id_string",
          ...
        ],
        "time": unix_time,
        "size": integer,
        "script": {
          "verification": "hash_string",
          "invocation": "hash_string"
        },
        "previousblockhash": "hash_string",
        "nonce": "hash_string",
        "nextconsensus": "hash_string",
        "nextblockhash": "hash_string",
        "merkleroot": "hash_string",
        "index": integer,
        "hash": "hash_string",
        "confirmations": integer
      }
  """
  def get_block(hash_or_integer) do
    block = Blocks.get(hash_or_integer)
    render_block(block)
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

  @doc """
  Returns the transaction model through its `hash_string`
  ## Examples
      /api/main_net/v1/get_transaction/{hash_string}
      {
        "vouts": [
          {
            "value": float,
            "n": integer,
            "asset": "name_string",
            "address": "hash_string"
          },
          ...
        ],
        "vin": [
          {
            "value": float,
            "txid": "tx_id_string",
            "n": integer,
            "asset": "name_string",
            "address_hash": "hash_string"
          },
          ...
        ],
        "version": integer,
        "type": "type_string",
        "txid": "tx_id_string",
        "time": unix_time,
        "sys_fee": "string",
        "size": integer,
        "scripts": [
          {
            "verification": "hash_string",
            "invocation": "hash_string"
          }
        ],
        "pubkey": hash_string,
        "nonce": integer,
        "net_fee": "string",
        "description": string,
        "contract": array,
        "claims": array,
        "block_height": integer,
        "block_hash": "hash_string",
        "attributes": array,
        "asset": array
      }
  """
  def get_transaction(hash) do
    transaction = Transactions.api_get(hash)
    render_transaction(transaction)
  end

  defp render_vout(vout) do
    %{
      value: vout.value,
      n: vout.n,
      asset: filter_name(vout.asset.name),
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

  @doc """
  Returns the last 15 transaction models in the chain for the selected address
  from its hash_string, paginated.
  ## Examples
      /api/main_net/v1/get_last_transactions_by_address/{hash_string}/{page}
      [{
          "vouts": [
            {
              "value": float,
              "n": integer,
              "asset": "name_string",
              "address": "hash_string"
            },
            ...
          ],
          "vin": [
            {
              "value": float,
              "txid": "tx_id_string",
              "n": integer,
              "asset": "name_string",
              "address_hash": "hash_string"
            },
            ...
          ],
          "transfers": [
            {
              "address_from": "hash_string",
              "address_to": "hash_string",
              "amount": "integer",
              "block_height": "integer",
              "txid": "tx_id_string",
              "contract": "token_contract_string",
              "time": "integer",
            },
            ...
          ],
          "version": integer,
          "type": "type_string",
          "txid": "tx_id_string",
          "time": unix_time,
          "sys_fee": "string",
          "size": integer,
          "scripts": [
            {
              "verification": "hash_string",
              "invocation": "hash_string"
            }
          ],
          "pubkey": hash_string,
          "nonce": integer,
          "net_fee": "string",
          "description": string,
          "contract": array,
          "claims": array,
          "block_height": integer,
          "block_hash": "hash_string",
          "attributes": array,
          "asset": array
        },
        ...
      ]
  """
  def get_last_transactions_by_address(address_hash, page) do
    transactions = Transactions.api_get_for_address(address_hash, page)
    Enum.map(transactions, &render_transaction/1)
  end

  @doc """
  Returns all working nodes and their respective heights.
  Information is updated each minute.
  Currrent tested nodes are:
  "http://seed1.cityofzion.io:8080",
  "http://seed2.cityofzion.io:8080",
  "http://seed3.cityofzion.io:8080",
  "http://seed4.cityofzion.io:8080",
  "http://seed5.cityofzion.io:8080",
  "http://api.otcgo.cn:10332",
  "https://seed1.neo.org:10331",
  "http://seed2.neo.org:10332",
  "http://seed3.neo.org:10332",
  "http://seed4.neo.org:10332",
  "http://seed5.neo.org:10332",
  "http://seed0.bridgeprotocol.io:10332",
  "http://seed1.bridgeprotocol.io:10332",
  "http://seed2.bridgeprotocol.io:10332",
  "http://seed3.bridgeprotocol.io:10332",
  "http://seed4.bridgeprotocol.io:10332",
  "http://seed5.bridgeprotocol.io:10332",
  "http://seed6.bridgeprotocol.io:10332",
  "http://seed7.bridgeprotocol.io:10332",
  "http://seed8.bridgeprotocol.io:10332",
  "http://seed9.bridgeprotocol.io:10332",
  "http://seed1.redpulse.com:10332",
  "http://seed2.redpulse.com:10332",
  "https://seed1.redpulse.com:10331",
  "https://seed2.redpulse.com:10331",
  "http://seed1.treatail.com:10332",
  "http://seed2.treatail.com:10332",
  "http://seed3.treatail.com:10332",
  "http://seed4.treatail.com:10332",
  "http://seed1.o3node.org:10332",
  "http://seed2.o3node.org:10332",
  "http://54.66.154.140:10332",
  "http://seed1.eu-central-1.fiatpeg.com:10332",
  "http://seed1.eu-west-2.fiatpeg.com:10332",
  "http://seed1.aphelion.org:10332",
  "http://seed2.aphelion.org:10332",
  "http://seed3.aphelion.org:10332",
  "http://seed4.aphelion.org:10332",
  ## Examples
      /api/main_net/v1/get_all_nodes
            [
              {
                "url": "http://seed1.cityofzion.io:8080",
          "height": 1239778
        },
        ...
      ]
  """
  def get_all_nodes do
    NeoscanNode.get_data()
    |> Enum.map(fn {url, height} -> %{url: url, height: height} end)
  end

  @doc """
  Returns the blockchain current height, as determined by the majority of
  working nodes.
  ## Examples
      /api/main_net/v1/get_height
      {
        "height": 1239809
      }
  """
  def get_height do
    %{:height => Counters.count_blocks() - 1}
  end

  @doc """
  Returns abstract models for an address from its `hash_string`, paginated
  ## Examples
      /api/main_net/v1/get_address_abstracts/{hash_string}/{page}
      [
        {
          "address_from": "hash_string",
          "address_to": "hash_string",
          "amount": string,
          "block_height": integer,
          "txid": "tx_id_string",
          "asset": "asset_id_string",
          "time": integer,
        },
        ...
      ]
  """
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
    |> to_string()
    |> String.trim_trailing("0")
    |> String.trim_trailing(".")
  end

  defp render_transaction_abstract_address("claim", _), do: "claim"

  defp render_transaction_abstract_address("multi", transaction_hash),
    do: Base.encode16(transaction_hash, case: :lower)

  defp render_transaction_abstract_address(address_hash, _), do: Base58.encode(address_hash)

  @doc """
  Returns abstract models for an address, to an address from their `hash_string`, paginated
  ## Examples
      /api/main_net/v1/get_address_to_address_abstracts/{hash_string}/{hash_string}/{page}
      [
        {
          "address_from": "hash_string",
          "address_to": "hash_string",
          "amount": string,
          "block_height": integer,
          "txid": "tx_id_string",
          "asset": "asset_id_string",
          "time": integer,
        },
        ...
      ]
  """
  def get_address_to_address_abstracts(_hash1, _hash2, _page) do
    %{entries: []}
    # TxAbstracts.get_address_to_address_abstracts(hash1, hash2, page)
  end

  defp filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => "AntShare"} ->
        "NEO"

      %{"name" => "AntCoin"} ->
        "GAS"

      %{"name" => name} ->
        name

      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end
end