defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses

  def page(conn, params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    addresses = Addresses.paginate_addresses(page)
    addresses = Enum.map(addresses, &Map.put(&1, :balance, Addresses.get_split_balance(&1.hash)))
    render(conn, "addresses.html", addresses: addresses, page: page)
  end
end
