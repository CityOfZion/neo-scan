defmodule NeoscanWeb.PageControllerTest do
  use NeoscanWeb.ConnCase
  import NeoscanWeb.Factory

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Your home for all NEO related blockchain information"

    conn =
      build_conn()
      |> put_req_header("accept-language", "fr")
      |> get("/")

    assert html_response(conn, 200) =~
             "Votre portail pour toutes les informations liées à la blockchain NEO"
  end

  test "POST /", %{conn: conn} do
    block = insert(:block)
    transaction = insert(:transaction)
    address = insert(:address)
    block_hash = Base.encode16(block.hash)
    transaction_hash = Base.encode16(transaction.hash)
    address_hash = Base58.encode(address.hash)
    conn = post(conn, "/", %{"search" => %{"for" => "random"}})
    assert "/" == redirected_to(conn, 302)
    conn = post(conn, "/", %{"search" => %{"for" => block_hash}})
    assert "/block/#{block_hash}" == redirected_to(conn, 302)
    conn = post(conn, "/", %{"search" => %{"for" => to_string(block.index)}})
    assert "/block/#{block_hash}" == redirected_to(conn, 302)
    conn = post(conn, "/", %{"search" => %{"for" => transaction_hash}})
    assert "/transaction/#{transaction_hash}" == redirected_to(conn, 302)
    conn = post(conn, "/", %{"search" => %{"for" => address_hash}})
    assert "/address/#{address_hash}" == redirected_to(conn, 302)
  end
end
