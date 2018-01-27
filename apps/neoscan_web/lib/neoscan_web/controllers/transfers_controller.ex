defmodule NeoscanWeb.TransfersController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Transfers

  def index(conn, _params) do
    transfers =
      Api.get_transfers()
      |> Enum.map(fn transfer ->
        {:ok, result} = Morphix.atomorphiform(transfer)
        result
      end)

    render(conn, "transfers.html", transfers: transfers, page: "1", type: nil)
  end

  def go_to_page(conn, %{"page" => page}) do
    transfers =
      Transfers.paginate_transfers(page)
      |> Enum.map(fn transfer ->
        {:ok, result} = Morphix.atomorphiform(transfer)
        result
      end)

    render(conn, "transfers.html", transfers: transfers, page: page, type: nil)
  end
end
