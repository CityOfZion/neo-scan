defmodule NeoscanWeb.BlockControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/block/:hash", %{conn: conn} do
    block = insert(:block)
    block_hash = Base.encode16(block.hash, case: :lower)
    conn = get(conn, "/block/#{block_hash}")
    body = html_response(conn, 200)
    assert body =~ block_hash

    block_hash_downcase = Base.encode16(block.hash, case: :lower)
    conn = get(conn, "/block/#{block_hash_downcase}")
    body = html_response(conn, 200)
    assert body =~ block_hash

    conn = get(conn, "/block/#{block_hash}/1")
    body = html_response(conn, 200)
    assert body =~ block_hash
  end
end
