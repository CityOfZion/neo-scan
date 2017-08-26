defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses

  def index(conn, %{"address" => address_hash}) do
    Addresses.get_address_by_hash_for_view(address_hash)
    |> route(conn)
  end

  def route(nil, conn) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(address, conn) do
    render(conn, "address.html", address: address)
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
