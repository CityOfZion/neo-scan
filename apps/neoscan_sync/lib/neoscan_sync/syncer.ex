defmodule NeoscanSync.Syncer do
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Address
  alias Neoscan.Repo

  require Logger

  @parallelism 8

  def convert_vin(vin_raw) do
    %Vin{
      vout_n: vin_raw.vout_n,
      vout_transaction_hash: vin_raw.vout_transaction_hash
    }
  end

  def convert_vout(vout_raw) do
    %Vout{
      n: vout_raw.n,
      address_hash: vout_raw.address,
      value: vout_raw.value,
      asset: vout_raw.asset
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
      vouts: Enum.map(transaction_raw.vouts, &convert_vout(&1)),
      vins: Enum.map(transaction_raw.vins, &convert_vin(&1))
    }
  end

  def create_addresses(block_raw) do
    addresses =
      for transaction_raw <- block_raw.tx do
        for %{address: hash} <- transaction_raw.vouts do
          %Address{
            hash: hash,
            first_transaction_time: block_raw.time,
            tx_count: 1,
            inserted_at: DateTime.utc_now(),
            updated_at: DateTime.utc_now()
          }
        end
      end

    addresses
    |> List.flatten()
    |> Enum.group_by(& &1.hash)
    |> Enum.map(fn {_, [address | _] = addresses} ->
      %{address | tx_count: Enum.count(addresses)}
    end)
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
      gas_generated: 0.0,
      tx_count: Enum.count(block_raw.tx)
    }
  end

  def import_block(index) do
    try do
      {:ok, block_raw} = NeoscanNode.get_block_by_height(index)
      block = convert_block(block_raw)
      addresses = create_addresses(block_raw)

      Repo.transaction(fn ->
        Repo.insert!(block)

        for address <- addresses do
          Ecto.Adapters.SQL.query!(
            Repo,
            """
            INSERT INTO addresses AS a (hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at)
            VALUES($1,$2,$3,$4,$5,$6)
            ON CONFLICT (hash) DO
            UPDATE SET
            tx_count = a.tx_count + EXCLUDED.tx_count,
            first_transaction_time = LEAST(a.first_transaction_time, EXCLUDED.first_transaction_time),
            last_transaction_time = GREATEST(a.last_transaction_time, EXCLUDED.last_transaction_time)
            """,
            [
              address.hash,
              address.first_transaction_time,
              address.first_transaction_time,
              address.tx_count,
              address.inserted_at,
              address.updated_at
            ]
          )
        end
      end)
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
