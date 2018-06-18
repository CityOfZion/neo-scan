defmodule NeoscanWeb.BlockControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/block/:hash", %{conn: conn} do
    block = insert(:block)
    block_hash = Base.encode16(block.hash)
    conn = get(conn, "/block/#{block_hash}")
    body = html_response(conn, 200)
    assert body =~ block_hash

    conn = get(conn, "/block/#{block_hash}/1")
    body = html_response(conn, 200)
    assert body =~ block_hash
  end
end
