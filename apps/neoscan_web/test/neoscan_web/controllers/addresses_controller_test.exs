defmodule NeoscanWeb.AddressesControllerTest do
  use NeoscanWeb.ConnCase

  alias NeoscanCache.Cache

  import NeoscanWeb.Factory

  test "/addresses/:page", %{conn: conn} do
    addresses = for _ <- 1..20, do: insert(:address)
    Cache.sync(%{tokens: []})

    conn = get(conn, "/addresses/1")
    body = html_response(conn, 200)
    assert body =~ Enum.at(addresses, 15).address
    assert not (body =~ Enum.at(addresses, 2).address)

    conn = get(conn, "/addresses/2")
    body = html_response(conn, 200)
    assert not (body =~ Enum.at(addresses, 15).address)
    assert body =~ Enum.at(addresses, 2).address
  end
end
