defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.NodeChecker
  alias NeoscanNode.Utils

  @timeout 60_000

  def get_last_block_index, do: NodeChecker.get_last_block_index()

  def get_live_nodes, do: NodeChecker.get_live_nodes()

  def get_block_with_transfers(index) do
    node_url = NodeChecker.get_random_node(index)
    {:ok, block} = NeoNode.get_block_by_height(node_url, index)

    updated_transactions = Utils.pmap2(block.tx, &update_transaction(&1, index), @timeout)

    Map.put(block, :tx, updated_transactions)
  end

  defp update_transaction(transaction, index) do
    Map.put(transaction, :transfers, get_transfers(transaction, index))
  end

  defp get_transfers(%{type: :invocation_transaction, hash: hash} = transaction, index) do
    node_url = NodeChecker.get_random_application_log_node(index)

    case NeoNode.get_application_log(node_url, Base.encode16(hash, case: :lower)) do
      {:ok, transfers} ->
        transfers

      _ ->
        get_transfers(transaction, index)
    end
  end

  defp get_transfers(_, _), do: []

  def get_tokens do
    {:ok, []}
  end
end
