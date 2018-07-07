# defmodule NeoscanWeb.TransfersControllerTest do
#  use NeoscanWeb.ConnCase
#
#  alias NeoscanCache.Cache
#
#  import NeoscanWeb.Factory
#
#  test "/transfers/:page", %{conn: conn} do
#    transfers = for _ <- 1..20, do: insert(:transfer)
#    Cache.sync(%{tokens: []})
#
#    conn = get(conn, "/transfers/1")
#    body = html_response(conn, 200)
#    assert body =~ Enum.at(transfers, 15).txid
#    assert not (body =~ Enum.at(transfers, 2).txid)
#
#    conn = get(conn, "/transfers/2")
#    body = html_response(conn, 200)
#    assert not (body =~ Enum.at(transfers, 15).txid)
#    assert body =~ Enum.at(transfers, 2).txid
#  end
# end
