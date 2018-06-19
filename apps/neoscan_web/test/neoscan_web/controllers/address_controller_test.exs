defmodule NeoscanWeb.AddressControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  @gas_asset_hash <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16, 132,
                    227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45, 231>>

  test "/address/:address", %{conn: conn} do
    address_history = insert(:address_history, %{asset_hash: @neo_asset_hash, value: 5.0})

    insert(:address_history, %{
      asset_hash: @gas_asset_hash,
      address_hash: address_history.address_hash,
      value: 9.5
    })

    balance_1 =
      insert(:address_history, %{address_hash: address_history.address_hash, value: 35.5})

    balance_2 =
      insert(:address_history, %{address_hash: address_history.address_hash, value: 432.5})

    insert(:asset, %{transaction_hash: @neo_asset_hash, name: [%{"en" => "NEO"}]})
    insert(:asset, %{transaction_hash: @gas_asset_hash, name: [%{"en" => "GAS"}]})
    insert(:asset, %{transaction_hash: balance_1.asset_hash, name: [%{"en" => "token 1"}]})
    insert(:asset, %{transaction_hash: balance_2.asset_hash, name: [%{"en" => "token 2"}]})
    # transaction = insert(:transaction, %{type: "contract_transaction"})
    # insert(:history, %{address_hash: address.address, txid: transaction.txid})

    transaction = insert(:transaction)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      transaction_hash: transaction.hash
    })

    address_hash = Base58.encode(address_history.address_hash)
    conn = get(conn, "/address/#{address_hash}")
    assert html_response(conn, 200) =~ address_hash
    assert html_response(conn, 200) =~ "5.0"
    assert html_response(conn, 200) =~ "9.5"
    assert html_response(conn, 200) =~ "token 1"
    assert html_response(conn, 200) =~ "token 2"

    conn = get(conn, "/address/abc")
    assert "/" == redirected_to(conn, 302)
  end

  #  test "/address/:address/:page", %{conn: conn} do
  #    address =
  #      insert(:address, %{
  #        balance: %{
  #          "assethash0" => %{
  #            "amount" => 50,
  #            "asset" => "assethash1"
  #          }
  #        }
  #      })
  #
  #    conn = get(conn, "/address/#{address.address}/1")
  #    assert html_response(conn, 200) =~ address.address
  #
  #    conn = get(conn, "/address/#{address.address}/2")
  #    assert html_response(conn, 200) =~ address.address
  #
  #    conn = get(conn, "/address/abc/1")
  #    assert "/" == redirected_to(conn, 302)
  #  end
end
