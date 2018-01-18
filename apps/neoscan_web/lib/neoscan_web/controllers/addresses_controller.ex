defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Addresses

  def index(conn, _params) do
    addresses = Api.get_addresses()
    render(conn, "addresses.html", addresses: addresses, page: "1")
  end

  def go_to_page(conn, %{"page" => page}) do
    addresses = Addresses.paginate_addresses(page)
    render(conn, "addresses.html", addresses: addresses, page: page)
  end
end
