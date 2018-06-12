# defmodule NeoscanWeb.TransactionControllerTest do
#  use NeoscanWeb.ConnCase
#
#  import NeoscanWeb.Factory
#
#  test "/transaction/:hash", %{conn: conn} do
#    for type <- [
#          "MinerTransaction",
#          "ContractTransaction",
#          "ClaimTransaction",
#          "IssueTransaction",
#          "RegisterTransaction",
#          "InvocationTransaction",
#          "PublishTransaction",
#          "EnrollmentTransaction",
#          "StateTransaction"
#        ] do
#      transaction = insert(:transaction, %{type: type})
#      conn = get(conn, "/transaction/#{transaction.txid}")
#      body = html_response(conn, 200)
#      assert body =~ transaction.txid
#    end
#
#    conn = get(conn, "/transaction/random")
#    assert "/" == redirected_to(conn, 302)
#  end
# end
