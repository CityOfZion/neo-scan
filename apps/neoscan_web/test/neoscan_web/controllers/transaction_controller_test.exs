defmodule NeoscanWeb.TransactionControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/transaction/:hash", %{conn: conn} do
    for type <- [
          "miner_transaction",
          "contract_transaction",
          "claim_transaction",
          "issue_transaction",
          "register_transaction",
          "invocation_transaction",
          "publish_transaction",
          "enrollment_transaction",
          "state_transaction"
        ] do
      transaction = insert(:transaction, %{type: type})
      insert(:asset, %{transaction_hash: transaction.hash})
      conn = get(conn, "/transaction/#{Base.encode16(transaction.hash)}")
      body = html_response(conn, 200)
      assert body =~ Base.encode16(transaction.hash)
    end

    #    conn = get(conn, "/transaction/random")
    #    assert "/" == redirected_to(conn, 302)
  end
end
