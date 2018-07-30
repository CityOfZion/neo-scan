defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.NodeChecker

  def get_height, do: NodeChecker.get_height()

  def get_data, do: NodeChecker.get_data()

  def get_block_with_transfers(index) do
    node_url = NodeChecker.get_random_node()
    {:ok, block} = NeoNode.get_block_by_height(node_url, index)
    notification_url = NodeChecker.get_random_notification()
    transfers = NeoNotification.get_block_transfers(notification_url, index)
    grouped_transfers = Enum.group_by(transfers, & &1.transaction_hash)

    updated_transactions =
      Enum.map(block.tx, fn transaction ->
        transfers = grouped_transfers[transaction.hash]
        transfers = if is_nil(transfers), do: [], else: transfers
        Map.put(transaction, :transfers, transfers)
      end)

    Map.put(block, :tx, updated_transactions)
  end

  def get_tokens do
    notification_url = NodeChecker.get_random_notification()
    NeoNotification.get_tokens(notification_url)
  end
end
