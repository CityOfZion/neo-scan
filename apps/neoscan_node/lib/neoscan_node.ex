defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.Worker
  alias NeoscanNode.Notifications

  def get_nodes do
    Worker.get_nodes()
  end

  def get_height do
    Worker.get_height()
  end

  def get_data do
    Worker.get_data()
  end

  def add_notifications(block, height) do
    Notifications.add_notifications(block, height)
  end

  def restart do
    Supervisor.terminate_child(NeoscanNode.Supervisor, NeoscanNode.Worker)
    Supervisor.restart_child(NeoscanNode.Supervisor, NeoscanNode.Worker)
  end
end
