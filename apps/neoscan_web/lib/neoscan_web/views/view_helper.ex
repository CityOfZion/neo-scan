defmodule NeoscanWeb.ViewHelper do
  @moduledoc "Contains function used in multiple views"
  use NeoscanWeb, :view
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers

  def get_GAS_balance(nil) do
    raw(
      ~s(<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span>GAS: 0.<span class="divisible-amount">0</span></p>)
    )
  end
  def get_GAS_balance(balance) do
    {int, div} = balance
                 |> Map.to_list
                 |> Enum.filter(
                      fn {_asset, %{"asset" => asset}} ->
                        Api.get_asset_name(asset) == "GAS"
                      end
                    )
                 |> Enum.reduce(
                      0.0,
                      fn ({_asset, %{"amount" => amount}}, acc) ->
                        amount + acc
                      end
                    )
                 |> Float.round(8)
                 |> Float.to_string
                 |> Integer.parse

    raw(
      ~s(<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span>GAS: ) <> "#{
        int
      }" <> ~s(<span class="divisible-amount">) <> "#{div}</span></p>"
    )
  end

  def get_NEO_balance(nil) do
    0
  end
  def get_NEO_balance(balance) do
    balance
    |> Map.to_list
    |> Enum.filter(
         fn {_asset, %{"asset" => asset}} ->
           Api.get_asset_name(asset) == "NEO"
         end
       )
    |> Enum.reduce(0, fn ({_asset, %{"amount" => amount}}, _acc) -> amount end)
    |> Helpers.round_or_not
  end
end
