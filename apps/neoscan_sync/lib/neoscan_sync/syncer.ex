defmodule NeoscanSync.Syncer do
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Claim
  alias Neoscan.Repo
  alias Neoscan.BlockGasGeneration

  require Logger

  @parallelism 8

  def convert_claim(claim_raw, block_raw) do
    %Claim{
      vout_n: claim_raw.vout_n,
      vout_transaction_hash: claim_raw.vout_transaction_hash,
      block_time: block_raw.time
    }
  end

  def convert_vin(vin_raw, block_raw) do
    %Vin{
      vout_n: vin_raw.vout_n,
      vout_transaction_hash: vin_raw.vout_transaction_hash,
      block_time: block_raw.time
    }
  end

  def convert_vout(vout_raw, block_raw) do
    %Vout{
      n: vout_raw.n,
      address_hash: vout_raw.address,
      value: vout_raw.value,
      asset: vout_raw.asset,
      block_time: block_raw.time
    }
  end

  def convert_transaction(transaction_raw, block_raw) do
    %Transaction{
      hash: transaction_raw.hash,
      block_index: block_raw.index,
      block_time: block_raw.time,
      attributes: transaction_raw.attributes,
      net_fee: transaction_raw.net_fee,
      sys_fee: transaction_raw.sys_fee,
      nonce: transaction_raw.nonce,
      scripts: transaction_raw.scripts,
      size: transaction_raw.size,
      type: to_string(transaction_raw.type),
      version: transaction_raw.version,
      vouts: Enum.map(transaction_raw.vouts, &convert_vout(&1, block_raw)),
      vins: Enum.map(transaction_raw.vins, &convert_vin(&1, block_raw)),
      claims: Enum.map(transaction_raw.claims, &convert_claim(&1, block_raw))
    }
  end

  def convert_block(block_raw) do
    %Block{
      hash: block_raw.hash,
      index: block_raw.index,
      merkle_root: block_raw.merkle_root,
      previous_block_hash: block_raw.previous_block_hash,
      next_block_hash: block_raw.next_block_hash,
      next_consensus: block_raw.next_consensus,
      nonce: block_raw.nonce,
      script: block_raw.script,
      size: block_raw.size,
      time: block_raw.time,
      version: block_raw.version,
      transactions: Enum.map(block_raw.tx, &convert_transaction(&1, block_raw)),
      total_sys_fee: Enum.sum(Enum.map(block_raw.tx, & &1.sys_fee)),
      total_net_fee: Enum.sum(Enum.map(block_raw.tx, & &1.net_fee)),
      gas_generated: BlockGasGeneration.get_amount_generate_in_block(block_raw.index),
      tx_count: Enum.count(block_raw.tx)
    }
  end

  def import_block(index) do
    try do
      {:ok, block_raw} = NeoscanNode.get_block_by_height(index)
      block = convert_block(block_raw)

      Repo.transaction(fn -> Repo.insert!(block) end)
    catch
      error ->
        Logger.error("error while loading block #{inspect({index, error})}")
        import_block(index)

      error, reason ->
        Logger.error("error while loading block #{inspect({index, error, reason})}")
        import_block(index)
    end
  end

  def sync_all() do
    concurrency = System.schedulers_online() * @parallelism

    Task.async_stream(
      0..1_000_000,
      fn n ->
        import_block(n)
        Logger.warn("block #{n}}")
      end,
      max_concurrency: concurrency,
      timeout: :infinity
    )
    |> Stream.run()
  end
end
