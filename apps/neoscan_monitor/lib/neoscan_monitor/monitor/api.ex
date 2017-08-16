defmodule NeoscanMonitor.Api do
  use GenServer

  def get_nodes do
    GenServer.call(NeoscanMonitor.Server, :nodes, 60000)
  end

  def get_height do
    GenServer.call(NeoscanMonitor.Server, :height, 60000)
  end

  def error do
    GenServer.cast(NeoscanMonitor.Server, :error)
  end

  def get_data do
    GenServer.call(NeoscanMonitor.Server, :data)
  end

end
