defmodule NeoscanWeb.AddressControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory
  alias Neoscan.Repo

  @governing_token Application.fetch_env!(:neoscan, :governing_token)
  @utility_token Application.fetch_env!(:neoscan, :utility_token)

  test "/address/:address", %{conn: conn} do
    address_history = insert(:address_history, %{asset_hash: @governing_token, value: 5.0})

    insert(:address_history, %{
      asset_hash: @utility_token,
      address_hash: address_history.address_hash,
      value: 9.5
    })

    balance_1 =
      insert(:address_history, %{address_hash: address_history.address_hash, value: 35.5})

    balance_2 =
      insert(:address_history, %{address_hash: address_history.address_hash, value: 432.5})

    insert(:asset, %{
      transaction_hash: @governing_token,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @utility_token,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    insert(:asset, %{
      transaction_hash: balance_1.asset_hash,
      name: [%{"lang" => "en", "name" => "token 1"}]
    })

    insert(:asset, %{
      transaction_hash: balance_2.asset_hash,
      name: [%{"lang" => "en", "name" => "token 2"}]
    })

    # transaction = insert(:transaction, %{type: "contract_transaction"})
    # insert(:history, %{address_hash: address.address, txid: transaction.txid})

    transaction = insert(:transaction)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      transaction_hash: transaction.hash
    })

    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_addresses_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_transaction_balances_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_balances_queue()", [])

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
