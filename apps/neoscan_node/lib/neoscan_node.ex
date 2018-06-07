defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.NodeChecker
  alias NeoscanNode.Notifications

  def get_nodes, do: NodeChecker.get_nodes()

  def get_height, do: NodeChecker.get_height()

  def get_data, do: NodeChecker.get_data()

  def add_notifications(block, height) do
    Notifications.add_notifications(block, height)
  end
end
