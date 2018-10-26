defmodule NeoscanSync.Converter do
  alias Neoscan.Block
  alias Neoscan.BlockGasGeneration
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Claim
  alias Neoscan.Transfer
  alias Neoscan.Transaction
  alias Neoscan.Asset

  def convert_claim(claim_raw, transaction_raw, block_raw) do
    %Claim{
      transaction_id: transaction_raw.id,
      vout_n: claim_raw.vout_n,
      vout_transaction_hash: claim_raw.vout_transaction_hash,
      block_time: block_raw.time,
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  def convert_vin(vin_raw, vin_n, transaction_raw, block_raw) do
    %Vin{
      transaction_id: transaction_raw.id,
      vout_n: vin_raw.vout_n,
      vout_transaction_hash: vin_raw.vout_transaction_hash,
      n: vin_n,
      block_index: block_raw.index,
      block_time: block_raw.time,
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  def convert_asset(nil, _, _), do: nil

  def convert_asset(asset_raw, transaction_raw, block_raw) do
    %Asset{
      transaction_id: transaction_raw.id,
      transaction_hash: transaction_raw.hash,
      admin: asset_raw.admin,
      amount: asset_raw.amount,
      name: asset_raw.name,
      owner: asset_raw.owner,
      precision: asset_raw.precision,
      type: to_string(asset_raw.type),
      issued: asset_raw.available,
      block_time: block_raw.time,
      contract: <<0>>,
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  def convert_transfer(transfer_raw, transaction_raw, block_raw) do
    %Transfer{
      transaction_id: transaction_raw.id,
      address_from: transfer_raw.addr_from,
      address_to: transfer_raw.addr_to,
      amount: transfer_raw.amount * 1.0,
      contract: transfer_raw.contract,
      block_index: block_raw.index,
      block_time: block_raw.time,
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  def convert_vout(vout_raw, transaction_raw, block_raw) do
    %Vout{
      transaction_id: transaction_raw.id,
      transaction_hash: transaction_raw.hash,
      n: vout_raw.n,
      address_hash: vout_raw.address,
      value: vout_raw.value,
      asset_hash: vout_raw.asset,
      claimed: false,
      spent: false,
      start_block_index: block_raw.index,
      block_time: block_raw.time,
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  # this function is a hack to prevent hash collision on miner transaction hash of the block 1826259 and 2000357, using
  # this hack prevent us from changing the data model (transaction hash is supposed to be unique), it might need to be
  # reviewed at a later time.
  def get_transaction_hash(%{type: :miner_transaction, hash: hash}, %{index: 2_000_357}) do
    :binary.encode_unsigned(:binary.decode_unsigned(hash) + 1)
  end

  def get_transaction_hash(transaction_raw, _), do: transaction_raw.hash

  def convert_transaction(transaction_raw, transaction_n, block_raw) do
    transaction_raw = Map.put(transaction_raw, :id, block_raw.index * 1_000_000 + transaction_n)

    %Transaction{
      id: transaction_raw.id,
      block_hash: block_raw.hash,
      hash: get_transaction_hash(transaction_raw, block_raw),
      block_index: block_raw.index,
      block_time: block_raw.time,
      net_fee: transaction_raw.net_fee,
      sys_fee: transaction_raw.sys_fee,
      nonce: transaction_raw.nonce,
      extra: transaction_raw.extra,
      size: transaction_raw.size,
      type: to_string(transaction_raw.type),
      version: transaction_raw.version,
      n: transaction_n,
      vouts: Enum.map(transaction_raw.vouts, &convert_vout(&1, transaction_raw, block_raw)),
      vins:
        map_with_index(transaction_raw.vins, &convert_vin(&1, &2, transaction_raw, block_raw)),
      claims: Enum.map(transaction_raw.claims, &convert_claim(&1, transaction_raw, block_raw)),
      transfers:
        Enum.map(transaction_raw.transfers, &convert_transfer(&1, transaction_raw, block_raw)),
      asset: convert_asset(transaction_raw.asset, transaction_raw, block_raw),
      inserted_at: block_raw.inserted_at,
      updated_at: block_raw.updated_at
    }
  end

  def convert_block(block_raw) do
    now = DateTime.utc_now()
    block_raw = Map.merge(block_raw, %{inserted_at: now, updated_at: now})

    %Block{
      hash: block_raw.hash,
      index: block_raw.index,
      merkle_root: block_raw.merkle_root,
      next_consensus: block_raw.next_consensus,
      nonce: block_raw.nonce,
      script: %{
        invocation: block_raw.script["invocation"],
        verification: block_raw.script["verification"]
      },
      size: block_raw.size,
      time: block_raw.time,
      version: block_raw.version,
      transactions: map_with_index(block_raw.tx, &convert_transaction(&1, &2, block_raw)),
      total_sys_fee: Enum.reduce(Enum.map(block_raw.tx, & &1.sys_fee), 0, &Decimal.add/2),
      total_net_fee: Enum.reduce(Enum.map(block_raw.tx, & &1.net_fee), 0, &Decimal.add/2),
      gas_generated: BlockGasGeneration.get_amount_generate_in_block(block_raw.index),
      tx_count: Enum.count(block_raw.tx)
    }
  end

  defp map_with_index(enumerable, fun) when is_list(enumerable) and is_function(fun, 2) do
    enumerable
    |> Enum.with_index()
    |> Enum.map(fn {item, index} -> fun.(item, index) end)
  end
end
