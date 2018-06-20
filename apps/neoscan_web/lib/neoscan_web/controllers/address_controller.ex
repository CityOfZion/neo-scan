defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias NeoscanWeb.Helper
  alias Neoscan.Transactions

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, parameters = %{"hash" => address_hash}) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    binary_hash = Helper.safe_decode_58(address_hash)
    address = Addresses.get(binary_hash)
    balance = Addresses.get_split_balance(binary_hash)

    if is_nil(address) do
      conn
      |> put_flash(:info, "Not Found in DB!")
      |> redirect(to: home_path(conn, :index))
    else
      transactions = Transactions.get_for_address(binary_hash, page)
      graph_data = []

      render(
        conn,
        "address.html",
        address: address,
        balance: balance,
        transactions: transactions,
        page: page,
        graph_data: graph_data
      )
    end
  end
end
