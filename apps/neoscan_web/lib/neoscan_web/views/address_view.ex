defmodule NeoscanWeb.AddressView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Helpers
  alias Neoscan.Assets
  import NeoscanWeb.CommonView

  def get_GAS_balance(nil) do
    raw('<p class="balance-amount">0<span>#{0}</span></p>')
  end

  def get_GAS_balance(balance) do
    {int, div} =
      balance
      |> Map.to_list()
      |> Enum.filter(fn {_asset, %{"asset" => asset}} ->
        CacheApi.get_asset_name(asset) == "GAS"
      end)
      |> Enum.reduce(0.0, fn {_asset, %{"amount" => amount}}, acc ->
        amount + acc
      end)
      |> Float.round(8)
      |> :erlang.float_to_binary(decimals: 8)
      |> String.trim_trailing("0")
      |> String.trim_trailing(".")
      |> Integer.parse()

    raw('<p class="balance-amount">#{number_to_delimited(int)}<span>#{div}</span></p>')
  end

  def get_token_balance(token) do
    precision = Assets.get_asset_precision_by_hash(token["asset"])

    {int, div} =
      token
      |> Map.get("amount")
      |> Helpers.apply_precision(token["asset"], precision)
      |> Integer.parse()

    raw('<p class="balance-amount">#{number_to_delimited(int)}<span>#{div}</span></p>')
  end

  def apply_precision(asset, amount) do
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
