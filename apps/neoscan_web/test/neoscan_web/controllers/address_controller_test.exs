defmodule NeoscanWeb.AddressControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory
  alias Neoscan.Flush

  @governing_token Application.fetch_env!(:neoscan, :governing_token)
  @utility_token Application.fetch_env!(:neoscan, :utility_token)

  test "/address/:address", %{conn: conn} do
    address_history = insert(:address_history, %{asset_hash: @governing_token, value: 5.0})

    insert(:address_history, %{
      asset_hash: @utility_token,
      address_hash: address_history.address_hash,
      value: Decimal.new("9.5")
    })

    balance_1 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        value: Decimal.new("35.5")
      })

    balance_2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        value: Decimal.new("432.5")
      })

    insert(:asset, %{
      transaction_hash: @governing_token,
      name: %{"en" => "NEO"}
    })

    insert(:asset, %{
      transaction_hash: @utility_token,
      name: %{"en" => "GAS"}
    })

    insert(:asset, %{
      transaction_hash: balance_1.asset_hash,
      name: %{"en" => "token 1"}
    })

    asset2 =
      insert(:asset, %{
        transaction_hash: balance_2.asset_hash,
        name: %{"en" => "token 2"}
      })

    # transaction = insert(:transaction, %{type: "contract_transaction"})
    # insert(:history, %{address_hash: address.address, txid: transaction.txid})

    transaction = insert(:transaction)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      transaction_id: transaction.id
    })

    insert(:transfer, %{
      transaction_id: transaction.id,
      address_from: <<0>>,
      contract: asset2.transaction_hash
    })

    Flush.all()

    address_hash = Base58.encode(address_history.address_hash)
    conn = get(conn, "/address/#{address_hash}")
    assert html_response(conn, 200) =~ address_hash
    assert html_response(conn, 200) =~ "5"
    assert html_response(conn, 200) =~ "9.5"
    assert html_response(conn, 200) =~ "token 1"
    assert html_response(conn, 200) =~ "token 2"

    conn = get(conn, "/address/#{address_hash}/1")
    assert html_response(conn, 200) =~ address_hash
    assert html_response(conn, 200) =~ "5"
    assert html_response(conn, 200) =~ "9.5"
    assert html_response(conn, 200) =~ "token 1"
    assert html_response(conn, 200) =~ "token 2"

    conn = get(conn, "/address/#{address_hash}/nan")
    assert "/" == redirected_to(conn, 302)

    conn = get(conn, "/address/abc")
    assert "/" == redirected_to(conn, 302)

    conn = get(conn, "/address/====")
    assert "/" == redirected_to(conn, 302)
  end
end
