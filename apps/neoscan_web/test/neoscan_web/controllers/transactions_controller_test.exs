# defmodule NeoscanWeb.TransactionsControllerTest do
#  use NeoscanWeb.ConnCase
#
#  alias NeoscanCache.Cache
#
#  import NeoscanWeb.Factory
#
#  test "/transactions/:page", %{conn: conn} do
#    transactions = for _ <- 1..11, do: insert(:transaction, %{type: "ContractTransaction"})
#
#    transactions2 =
#      for type <- [
#            "MinerTransaction",
#            "ContractTransaction",
#            "ClaimTransaction",
#            "IssueTransaction",
#            "RegisterTransaction",
#            "InvocationTransaction",
#            "PublishTransaction",
#            "EnrollmentTransaction",
#            "StateTransaction"
#          ] do
#        insert(:transaction, %{type: type})
#      end
#
#    transactions = transactions ++ transactions2
#    insert(:transfer, %{txid: Enum.at(transactions, 15).txid})
#    insert(:transfer, %{txid: Enum.at(transactions, 2).txid})
#
#    Cache.sync(%{tokens: []})
#
#    conn = get(conn, "/transactions/1")
#    body = html_response(conn, 200)
#    assert body =~ Enum.at(transactions, 15).txid
#    assert not (body =~ Enum.at(transactions, 2).txid)
#
#    conn = get(conn, "/transactions/2")
#    body = html_response(conn, 200)
#    assert not (body =~ Enum.at(transactions, 15).txid)
#    assert body =~ Enum.at(transactions, 2).txid
#  end
#
#  test "/transactions/type/:type/:page", %{conn: conn} do
#    transactions = for _ <- 1..20, do: insert(:transaction, %{type: "ContractTransaction"})
#    for _ <- 1..3, do: insert(:transaction, %{type: "InvocationTransaction"})
#
#    insert(:transfer, %{txid: Enum.at(transactions, 2).txid})
#
#    conn = get(conn, "/transactions/type/contract/1")
#    body = html_response(conn, 200)
#    assert body =~ Enum.at(transactions, 15).txid
#    assert not (body =~ Enum.at(transactions, 2).txid)
#
#    conn = get(conn, "/transactions/type/contract/2")
#    body = html_response(conn, 200)
#    assert not (body =~ Enum.at(transactions, 15).txid)
#    assert body =~ Enum.at(transactions, 2).txid
#  end
# end
