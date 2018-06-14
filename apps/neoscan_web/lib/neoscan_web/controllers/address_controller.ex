defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias NeoscanWeb.Helper

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, parameters = %{"address" => address_hash}) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    binary_hash = Helper.safe_decode_58(address_hash)
    address = Addresses.get(binary_hash)
    balance = Addresses.get_split_balance(binary_hash)

    if is_nil(address) do
      conn
      |> put_flash(:info, "Not Found in DB!")
      |> redirect(to: home_path(conn, :index))
    else
      transactions = Addresses.get_transactions(binary_hash)
      graph_data = []

      render(
        conn,
        "address.html",
        address: %{
          hash: Base58.encode(address.hash),
          tx_count: address.tx_count
        },
        balance: balance,
        transactions: transactions,
        page: page,
        graph_data: graph_data
      )
    end
  end
end
