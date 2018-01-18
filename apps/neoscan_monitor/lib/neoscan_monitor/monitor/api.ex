defmodule NeoscanMonitor.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """
  alias NeoscanMonitor.Server
  alias NeoscanMonitor.Worker
  alias Neoscan.ChainAssets

  def get_nodes do
    Server.get(:monitor)
    |> Map.get(:nodes)
  end

  def get_height do
    Server.get(:monitor)
    |> Map.get(:height)
  end

  def get_blocks do
    Server.get(:blocks)
  end

  def get_transactions do
    Server.get(:transactions)
  end

  def get_assets do
    Server.get(:assets)
  end

  def get_asset(hash) do
    Server.get(:assets)
    |> Enum.find(fn %{:txid => txid} -> txid == hash end)
  end

  def get_asset_name(hash) do
    Server.get(:assets)
    |> Enum.find(fn %{:txid => txid} -> txid == hash end)
    |> Map.get(:name)
    |> ChainAssets.filter_name()
  end

  def check_asset(hash) do
    Server.get(:assets)
    |> Enum.any?(fn %{:txid => txid} -> txid == hash end)
  end

  def get_addresses do
    Server.get(:addresses)
  end

  def get_contracts do
    Server.get(:contracts)
  end

  def error do
    GenServer.cast(NeoscanMonitor.Worker, :update_nodes)
  end

  def get_data do
    Server.get(:monitor)
    |> Map.get(:data)
  end

  def get_price do
    Server.get(:price)
  end

  def get_stats do
    Server.get(:stats)
  end

  def add_block(block) do
    Worker.add_block(block)
  end

  def add_transaction(transaction, vouts) do
    Worker.add_transaction(transaction, vouts)
  end
end
