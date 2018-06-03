defmodule NeoscanWeb.AddressControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/address/:address", %{conn: conn} do
    address =
      insert(:address, %{
        balance: %{
          "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b" => %{
            "amount" => 50,
            "asset" => "assethash1"
          }
        }
      })

    transaction = insert(:transaction, %{type: "ContractTransaction"})
    insert(:history, %{address_hash: address.address, txid: transaction.txid})

    conn = get(conn, "/address/#{address.address}")
    assert html_response(conn, 200) =~ address.address

    conn = get(conn, "/address/abc")
    assert "/" == redirected_to(conn, 302)
  end

  test "/address/:address/:page", %{conn: conn} do
    address =
      insert(:address, %{
        balance: %{
          "assethash0" => %{
            "amount" => 50,
            "asset" => "assethash1"
          }
        }
      })

    conn = get(conn, "/address/#{address.address}/1")
    assert html_response(conn, 200) =~ address.address

    conn = get(conn, "/address/#{address.address}/2")
    assert html_response(conn, 200) =~ address.address

    conn = get(conn, "/address/abc/1")
    assert "/" == redirected_to(conn, 302)
  end
end
