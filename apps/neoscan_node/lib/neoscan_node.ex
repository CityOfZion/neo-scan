defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.NodeChecker
  alias NeoscanNode.Blockchain

  def get_nodes, do: NodeChecker.get_nodes()

  def get_height, do: NodeChecker.get_height()

  def get_data, do: NodeChecker.get_data()

  def get_block_by_height(height), do: Blockchain.get_block_by_height(height)
end
