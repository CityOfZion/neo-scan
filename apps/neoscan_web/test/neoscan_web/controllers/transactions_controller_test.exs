defmodule NeoscanWeb.TransactionsControllerTest do
  use NeoscanWeb.ConnCase

  alias NeoscanCache.Cache

  import NeoscanWeb.Factory

  test "/transactions/:page", %{conn: conn} do
    transactions = for _ <- 1..11, do: insert(:transaction, %{type: "contract_transaction"})

    transactions2 =
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
        transaction
      end

    asset = insert(:asset)

    transactions = transactions ++ transactions2

    insert(:transfer, %{
      contract: asset.transaction_hash,
      transaction_hash: Enum.at(transactions, 15).hash
    })

    insert(:transfer, %{
      contract: asset.transaction_hash,
      transaction_hash: Enum.at(transactions, 2).hash
    })

    Cache.sync()

    conn = get(conn, "/transactions/1")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(Enum.at(transactions, 15).hash, case: :lower)
    assert not (body =~ Base.encode16(Enum.at(transactions, 2).hash, case: :lower))

    conn = get(conn, "/transactions/2")
    body = html_response(conn, 200)
    assert not (body =~ Base.encode16(Enum.at(transactions, 15).hash, case: :lower))
    assert body =~ Base.encode16(Enum.at(transactions, 2).hash, case: :lower)

    conn = get(conn, "/transactions/====")
    assert "/" == redirected_to(conn, 302)
  end
end
