defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias Neoscan.BalanceHistories

  def index(conn, %{"address" => address_hash}) do
    Addresses.get_address_by_hash_for_view(address_hash)
    |> route(conn, "1")
  end

  def go_to_page(conn, %{"address" => address_hash, "page" => page}) do
    Addresses.get_address_by_hash_for_view(address_hash)
    |> route(conn, page)
  end

  def route(nil, conn, _page) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(address, conn, page) do
    transactions = BalanceHistories.paginate_history_transactions(address.histories, page)
                    |> Enum.map(fn tr ->
                      {:ok, result} = Morphix.atomorphiform(tr)
                      result
                     end)
    render(conn, "address.html", address: address, transactions: transactions, page: page)
  end

end
