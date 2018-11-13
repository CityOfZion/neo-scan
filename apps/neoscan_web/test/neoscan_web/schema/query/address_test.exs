defmodule NeoscanWeb.Schema.Query.AddressTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  @query """
  query Address($hash: String!){
    address(hash: $hash){
      hash
      first_transaction_time
      last_transaction_time
      tx_count
      atb_count
    }
  }
  """
  test "get one block by hash", %{conn: conn} do
    address = insert(:address)

    hash = Base58.encode(address.hash)

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: @query,
          variables: %{
            hash: hash
          }
        }
      )

    body = json_response(conn, 200)

    assert %{
             "data" => %{
               "address" => %{
                 "atb_count" => _,
                 "first_transaction_time" => _,
                 "hash" => ^hash,
                 "last_transaction_time" => _,
                 "tx_count" => _
               }
             }
           } = body
  end
end
