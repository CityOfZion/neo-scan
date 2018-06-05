defmodule NeoscanWeb.BlocksControllerTest do
  use NeoscanWeb.ConnCase

  alias NeoscanCache.Cache
  import NeoscanWeb.Factory

  test "/blocks/:page", %{conn: conn} do
    block = insert(:block, %{index: 13_456})
    Cache.sync(%{tokens: []})
    conn = get(conn, "/blocks/1")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(block.hash)

    conn = get(conn, "/blocks/2")
    body = html_response(conn, 200)
    assert not (body =~ Base.encode16(block.hash))
  end
end
