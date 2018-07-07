defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.NodeChecker
  alias NeoscanNode.Blockchain
  alias NeoscanNode.Notifications

  def get_nodes, do: NodeChecker.get_nodes()

  def get_height, do: NodeChecker.get_height()

  def get_data, do: NodeChecker.get_data()

  def get_block_by_height(height), do: Blockchain.get_block_by_height(height)

  def get_block_transfers_by_height(height),
    do: Notifications.get_transfer_block_notifications(height)

  def get_block_with_transfers(index) do
    {:ok, block} = get_block_by_height(index)
    transfers = get_block_transfers_by_height(index)
    grouped_transfers = Enum.group_by(transfers, & &1.transaction_hash)

    updated_transactions =
      Enum.map(block.tx, fn transaction ->
        transfers = grouped_transfers[transaction.hash]
        transfers = if is_nil(transfers), do: [], else: transfers
        Map.put(transaction, :transfers, transfers)
      end)

    Map.put(block, :tx, updated_transactions)
  end
end
