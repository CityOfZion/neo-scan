defmodule NeoscanWeb.AddressesController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias Neoscan.Counters

  @page_spec [
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def page(conn, params) do
    if_valid_query conn, params, @page_spec do
      addresses = Addresses.paginate(parsed.page)

      addresses =
        Enum.map(addresses, &Map.put(&1, :balance, Addresses.get_split_balance(&1.hash)))

      total = Counters.count_addresses()
      render(conn, "addresses.html", addresses: addresses, page: parsed.page, total: total)
    end
  end
end
