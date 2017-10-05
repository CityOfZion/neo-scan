defmodule NeoscanMonitor.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """

  def get_nodes do
    GenServer.call(NeoscanMonitor.Server, :nodes, 10_000)
  end

  def get_height do
    GenServer.call(NeoscanMonitor.Server, :height, 10_000)
  end

  def get_blocks do
    GenServer.call(NeoscanMonitor.Server, :blocks, 10_000)
  end

  def get_transactions do
    GenServer.call(NeoscanMonitor.Server, :transactions, 10_000)
  end

  def get_assets do
    GenServer.call(NeoscanMonitor.Server, :assets, 10_000)
  end

  def get_asset_name(hash) do
    GenServer.call(NeoscanMonitor.Server, {:asset_name, hash}, 10_000)
  end

  def get_addresses do
    GenServer.call(NeoscanMonitor.Server, :addresses, 10_000)
  end

  def get_contracts do
    GenServer.call(NeoscanMonitor.Server, :contracts, 10_000)
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

  def add_transaction(transaction, vouts) do
    GenServer.cast(
      NeoscanMonitor.Worker,
      {:add_transaction, transaction, vouts}
    )
  end

  def add_asset(asset) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_asset, asset})
  end

  def add_contract(contract, vouts) do
    GenServer.cast(NeoscanMonitor.Worker, {:add_contract, contract, vouts})
  end

end
