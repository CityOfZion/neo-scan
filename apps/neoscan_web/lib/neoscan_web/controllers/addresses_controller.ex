defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Addresses

  def index(conn, _params) do
    addresses = CacheApi.get_addresses()
    render(conn, "addresses.html", addresses: addresses, page: "1")
  end

  def go_to_page(conn, %{"page" => page}) do
    addresses = Addresses.paginate_addresses(page)
    render(conn, "addresses.html", addresses: addresses, page: page)
  end
end
