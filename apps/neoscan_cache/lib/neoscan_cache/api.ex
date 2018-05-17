defmodule NeoscanCache.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """
  alias NeoscanCache.Cache
  alias Neoscan.ChainAssets

  def get_blocks do
    Cache.get(:blocks)
  end

  def get_transfers do
    Cache.get(:transfers)
  end

  def get_transactions do
    Cache.get(:transactions)
  end

  def get_assets do
    assets = Cache.get(:assets)
    if is_nil(assets), do: [], else: assets
  end

  def get_asset(hash) do
    Cache.get(:assets)
    |> Enum.find(fn %{:txid => txid} -> txid == hash end)
  end

  def get_asset_name(hash) do
    cond do
      String.length(hash) == 40 ->
        Cache.get(:assets)
        |> Enum.find(fn %{:contract => contract} -> contract == hash end)
        |> (&if(is_nil(&1), do: %{}, else: &1)).()
        |> Map.get(:name)
        |> ChainAssets.filter_name()

      true ->
        Cache.get(:assets)
        |> Enum.find(fn %{:txid => txid} -> txid == hash end)
        |> (&if(is_nil(&1), do: %{}, else: &1)).()
        |> Map.get(:name)
        |> ChainAssets.filter_name()
    end
  end

  def check_asset(hash) do
    Cache.get(:assets)
    |> Enum.any?(fn %{:txid => txid} -> txid == hash end)
  end

  def get_addresses do
    Cache.get(:addresses)
  end

  def get_contracts do
    Cache.get(:contracts)
  end

  def get_price do
    Cache.get(:price)
  end

  def get_stats do
    Cache.get(:stats)
  end
end
