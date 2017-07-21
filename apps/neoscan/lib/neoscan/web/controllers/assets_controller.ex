defmodule Neoscan.Web.AssetsController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_assets(conn, _params) do
    assets = Transactions.list_assets()
    |> IO.inspect
    render(conn, "assets.html", assets: assets)
  end

  def round_or_not(value) do
    cond do
      Kernel.round(value) == value ->
        Kernel.round(value)
      Kernel.round(value) != value ->
        value
    end
  end


end
