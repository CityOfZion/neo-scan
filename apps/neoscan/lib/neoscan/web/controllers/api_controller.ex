defmodule Neoscan.Web.ApiController do
  use Neoscan.Web, :controller

  alias Neoscan.Api

  def show_json(conn, %{"hash" => hash}) do
    # address = Addresses.get_address_by_hash_for_view(address_hash)
    # render(conn, "address.html", address: address)
  end


end
