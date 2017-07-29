defmodule NeoscanWeb.AssetsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def show_assets(conn, _params) do
    assets = Transactions.list_assets()
    render(conn, "assets.html", assets: assets)
  end

  def round_or_not(value) do
    cond do
      Kernel.round(value) == value ->
        Kernel.round(value)
        |> check()
      Kernel.round(value) != value ->
        value
        |> check()
    end
  end

  def check(value) do
    cond do
      value < 0 ->
        "Unlimited"

      true ->
        value
    end
  end


end
