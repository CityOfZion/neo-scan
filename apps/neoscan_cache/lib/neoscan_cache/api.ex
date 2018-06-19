defmodule NeoscanCache.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """
  alias NeoscanCache.Cache

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

  def get_asset_name(asset_hash) do
    Cache.get(:assets)
    |> Enum.find(fn %{transaction_hash: transaction_hash} -> transaction_hash == asset_hash end)
    |> (&if(is_nil(&1), do: %{}, else: &1)).()
    |> Map.get(:name)
    |> filter_name()
  end

  defp filter_name(nil), do: "Asset not Found"

  defp filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => "AntShare"} ->
        "NEO"

      %{"name" => "AntCoin"} ->
        "GAS"

      %{"name" => name} ->
        name

      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end

  def check_asset(hash) do
    Cache.get(:assets)
    |> Enum.any?(fn %{:txid => txid} -> txid == hash end)
  end

  def get_addresses do
    Cache.get(:addresses)
  end

  def get_price do
    Cache.get(:price)
  end

  def get_stats do
    Cache.get(:stats)
  end
end
