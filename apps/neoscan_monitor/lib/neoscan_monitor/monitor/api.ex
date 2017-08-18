defmodule NeoscanMonitor.Api do
  use GenServer

  def get_nodes do
    GenServer.call(NeoscanMonitor.Server, :nodes, 10000)
  end

  def get_height do
    GenServer.call(NeoscanMonitor.Server, :height, 10000)
  end

  def error do
    GenServer.cast(NeoscanMonitor.Worker, :update)
  end

  def get_data do
    GenServer.call(NeoscanMonitor.Server, :data)
  end

end
