defmodule NeoscanWeb.PageControllerTest do
  use NeoscanWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Your home for all NEO related blockchain information"
  end
end
