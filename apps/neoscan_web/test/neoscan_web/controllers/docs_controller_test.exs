defmodule NeoscanWeb.DocsControllerTest do
  use NeoscanWeb.ConnCase

  test "/docs", %{conn: conn} do
    conn = get(conn, "/docs")
    assert "/docs/index.html" == redirected_to(conn, 302)
  end
end
