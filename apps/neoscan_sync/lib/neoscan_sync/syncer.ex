defmodule NeoscanSync.Syncer do
  alias Neoscan.Block
  alias Neoscan.Repo

  def import_block(index) do
    {:ok, block_raw} = NeoscanNode.get_block_by_height(index)

    block = %Block{
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
      total_sys_fee: 0.0,
      total_net_fee: 0.0,
      gas_generated: 0.0,
      tx_count: Enum.count(block_raw.tx)
    }

    Repo.transaction(fn ->
      Repo.insert!(block)
    end)
  end
end
