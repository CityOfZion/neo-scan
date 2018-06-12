# defmodule NeoscanWeb.PageControllerTest do
#  use NeoscanWeb.ConnCase
#  import NeoscanWeb.Factory
#
#  test "GET /", %{conn: conn} do
#    conn = get(conn, "/")
#    assert html_response(conn, 200) =~ "Your home for all NEO related blockchain information"
#
#    conn =
#      build_conn()
#      |> put_req_header("accept-language", "fr")
#      |> get("/")
#
#    assert html_response(conn, 200) =~
#             "Votre portail pour toutes les informations liées à la blockchain NEO"
#  end
#
#  test "POST /", %{conn: conn} do
#    block_hash = "012345b789012345678901234567890123456789012345678901234567891234"
#    transaction_hash = "012345b789012345678901234567890123456789012345678901234567891235"
#    block = insert(:block, %{hash: block_hash, index: 12})
#    insert(:transaction, %{txid: transaction_hash})
#    address = insert(:address)
#    conn = post(conn, "/", %{"search" => %{"for" => "random"}})
#    assert "/" == redirected_to(conn, 302)
#    conn = post(conn, "/", %{"search" => %{"for" => block.hash}})
#    assert "/block/#{block_hash}" == redirected_to(conn, 302)
#    conn = post(conn, "/", %{"search" => %{"for" => "12"}})
#    assert "/block/#{block_hash}" == redirected_to(conn, 302)
#    conn = post(conn, "/", %{"search" => %{"for" => transaction_hash}})
#    assert "/transaction/#{transaction_hash}" == redirected_to(conn, 302)
#    conn = post(conn, "/", %{"search" => %{"for" => address.address}})
#    assert "/address/#{address.address}" == redirected_to(conn, 302)
#  end
# end
