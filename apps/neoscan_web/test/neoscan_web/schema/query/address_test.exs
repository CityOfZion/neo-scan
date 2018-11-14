defmodule NeoscanWeb.Schema.Query.AddressTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  @query """
  query Address($hash: String!, $start_block: Int!, $end_block: Int!){
    address(hash: $hash){
      hash
      first_transaction_time
      last_transaction_time
      tx_count
      atb_count
      gas_generated(start_block: $start_block, end_block: $end_block)
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
            hash: hash,
            start_block: 12,
            end_block: 15
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
                 "gas_generated" => "0.0",
                 "last_transaction_time" => _,
                 "tx_count" => _
               }
             }
           } = body
  end
end
