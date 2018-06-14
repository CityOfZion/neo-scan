defmodule NeoscanWeb.DocControllerTest do
  use NeoscanWeb.ConnCase

  test "/doc", %{conn: conn} do
    conn = get(conn, "/doc")
    assert "/doc/Neoscan.Api.html" == redirected_to(conn, 302)
  end
end
