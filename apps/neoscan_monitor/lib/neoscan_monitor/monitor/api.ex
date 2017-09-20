defmodule NeoscanMonitor.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """

  def get_nodes do
    GenServer.call(NeoscanMonitor.Server, :nodes, 10000)
  end

  def get_height do
    GenServer.call(NeoscanMonitor.Server, :height, 10000)
  end

  def get_blocks do
    GenServer.call(NeoscanMonitor.Server, :blocks, 10000)
  end

  def get_transactions do
    GenServer.call(NeoscanMonitor.Server, :transactions, 10000)
  end

  def get_assets do
    GenServer.call(NeoscanMonitor.Server, :assets, 10000)
  end

  def get_contracts do
    GenServer.call(NeoscanMonitor.Server, :contracts, 10000)
  end

  def error do
    GenServer.cast(NeoscanMonitor.Worker, :update_nodes)
  end

  def get_data do
    GenServer.call(NeoscanMonitor.Server, :data)
  end

  def add_block(block) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_block, block})
  end

  def add_transaction(transaction) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_transaction, transaction})
  end

  def add_asset(asset) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_asset, asset})
  end

  def add_contract(contract) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_contract, contract})
  end

end
