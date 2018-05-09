defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api, as: MonitorApi
  alias Neoscan.Addresses

  def index(conn, _params) do
    addresses = MonitorApi.get_addresses()
    render(conn, "addresses.html", addresses: addresses, page: "1")
  end

  def go_to_page(conn, %{"page" => page}) do
    addresses = Addresses.paginate_addresses(page)
    render(conn, "addresses.html", addresses: addresses, page: page)
  end
end
