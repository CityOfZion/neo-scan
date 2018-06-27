defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias Neoscan.Counters

  def page(conn, params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    addresses = Addresses.paginate(page)
    addresses = Enum.map(addresses, &Map.put(&1, :balance, Addresses.get_split_balance(&1.hash)))
    total = Counters.count_addresses()
    render(conn, "addresses.html", addresses: addresses, page: page, total: total)
  end
end
