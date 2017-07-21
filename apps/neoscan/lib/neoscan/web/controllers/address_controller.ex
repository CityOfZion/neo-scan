defmodule Neoscan.Web.AddressController do
  use Neoscan.Web, :controller

  alias Neoscan.Addresses

  def show_address(conn, %{"address" => address_hash}) do
    address = Addresses.get_address_by_hash_for_view(address_hash)
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
