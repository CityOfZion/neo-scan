defmodule NeoscanWeb.AddressesControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/addresses/:page", %{conn: conn} do
    addresses = for _ <- 1..20, do: insert(:address)

    conn = get(conn, "/addresses/1")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(Enum.at(addresses, 15).hash)
    assert not (body =~ Base.encode16(Enum.at(addresses, 2).hash))

    conn = get(conn, "/addresses/2")
    body = html_response(conn, 200)
    assert not (body =~ Base.encode16(Enum.at(addresses, 15).hash))
    assert body =~ Base.encode16(Enum.at(addresses, 2).hash)
  end
end
