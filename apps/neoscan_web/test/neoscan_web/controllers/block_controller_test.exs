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

    conn = get(conn, "/block/#{block_hash}/nan")
    assert "/" == redirected_to(conn, 302)

    conn = get(conn, "/block/nan")
    assert "/" == redirected_to(conn, 302)

    conn = get(conn, "/block/1e")
    assert "/" == redirected_to(conn, 302)
  end
end
