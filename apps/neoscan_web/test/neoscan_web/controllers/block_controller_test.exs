defmodule NeoscanWeb.BlockControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/block/:hash", %{conn: conn} do
    block = insert(:block)
    transaction = insert(:transaction, %{block_hash: block.hash, type: "ContractTransaction"})
    insert(:transfer, %{txid: transaction.txid})
    conn = get(conn, "/block/#{Base.encode16(block.hash)}")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(block.hash)
  end

  test "/block/:hash/:page", %{conn: conn} do
    block = insert(:block)
    transaction = insert(:transaction, %{block_hash: block.hash, type: "ContractTransaction"})
    insert(:transfer, %{txid: transaction.txid})
    conn = get(conn, "/block/#{Base.encode16(block.hash)}/1")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(block.hash)
  end
end
