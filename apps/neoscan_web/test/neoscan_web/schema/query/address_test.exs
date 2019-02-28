defmodule NeoscanWeb.Schema.Query.AddressTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory
  alias Neoscan.Flush
  @utility_token Application.fetch_env!(:neoscan, :utility_token)

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

  test "transaction abstract", %{conn: conn} do
    query = """
    query Address($hash: String!, $start_timestamp: Int!, $end_timestamp: Int!, $limit: Int!){
      address(hash: $hash){
        transaction_abstracts(start_timestamp: $start_timestamp, end_timestamp: $end_timestamp, limit: $limit){
          txid
          time
          block_height
          asset
          amount
          address_to
          address_from
        }
      }
    }
    """

    asset = insert(:asset)
    asset_hash = asset.transaction_hash
    asset_hash_str = Base.encode16(asset_hash, case: :lower)

    # claim transaction (no vin, but 1 vout) address is receiver
    transaction1 = insert(:transaction, %{type: "claim_transaction"})

    vout =
      insert(
        :vout,
        %{
          transaction_id: transaction1.id,
          transaction_hash: transaction1.hash,
          asset_hash: @utility_token,
          value: Decimal.new("5.1")
        }
      )

    address_hash = vout.address_hash
    address_hash_str = Base58.encode(address_hash)

    insert(
      :vout,
      %{
        transaction_id: transaction1.id,
        transaction_hash: transaction1.hash,
        asset_hash: asset_hash,
        value: Decimal.new("2.1")
      }
    )

    insert(
      :vout,
      %{
        transaction_id: transaction1.id,
        transaction_hash: transaction1.hash,
        asset_hash: asset_hash,
        value: Decimal.new("3.0")
      }
    )

    # normal transaction (1 vin 2 vouts) address is receiver, receive 5.0
    transaction2 = insert(:transaction)

    vout4 =
      insert(
        :vout,
        %{
          address_hash: address_hash,
          transaction_id: transaction2.id,
          transaction_hash: transaction2.hash,
          asset_hash: asset_hash,
          value: Decimal.new("50.0")
        }
      )

    vout2 = insert(:vout, %{asset_hash: asset_hash, value: Decimal.new("7.0")})

    insert(
      :vin,
      %{
        transaction_id: transaction2.id,
        vout_n: vout2.n,
        vout_transaction_hash: vout2.transaction_hash
      }
    )

    insert(
      :vout,
      %{
        transaction_id: transaction2.id,
        transaction_hash: transaction2.hash,
        asset_hash: asset_hash,
        value: Decimal.new("2.0")
      }
    )

    # normal transaction address is sender
    transaction3 = insert(:transaction)

    vout3 =
      insert(
        :vout,
        %{
          transaction_id: transaction3.id,
          transaction_hash: transaction3.hash,
          asset_hash: asset_hash,
          value: Decimal.new("5.0")
        }
      )

    insert(
      :vin,
      %{
        transaction_id: transaction3.id,
        vout_n: vout4.n,
        vout_transaction_hash: vout4.transaction_hash
      }
    )

    # multi transaction (2 vins 1 vout)
    transaction5 = insert(:transaction)

    vout5 =
      insert(
        :vout,
        %{
          transaction_id: transaction5.id,
          transaction_hash: transaction5.hash,
          asset_hash: asset_hash,
          value: Decimal.new("9.0")
        }
      )

    transaction4 = insert(:transaction)

    vout6 =
      insert(
        :vout,
        %{
          address_hash: address_hash,
          transaction_id: transaction4.id,
          transaction_hash: transaction4.hash,
          asset_hash: asset_hash,
          value: Decimal.new("14.0")
        }
      )

    insert(
      :vin,
      %{
        transaction_id: transaction4.id,
        vout_n: vout3.n,
        vout_transaction_hash: vout3.transaction_hash
      }
    )

    insert(
      :vin,
      %{
        transaction_id: transaction4.id,
        vout_n: vout5.n,
        vout_transaction_hash: vout5.transaction_hash
      }
    )

    # multi transaction (1 vin 2 vouts) where vin has the same address hash than 1 vout
    transaction6 = insert(:transaction)

    insert(
      :vout,
      %{
        address_hash: address_hash,
        transaction_id: transaction6.id,
        transaction_hash: transaction6.hash,
        asset_hash: asset_hash,
        value: Decimal.new("13.0")
      }
    )

    vout7 =
      insert(
        :vout,
        %{
          transaction_id: transaction6.id,
          transaction_hash: transaction6.hash,
          asset_hash: asset_hash,
          value: Decimal.new("1.0")
        }
      )

    insert(
      :vin,
      %{
        transaction_id: transaction6.id,
        vout_n: vout6.n,
        vout_transaction_hash: vout6.transaction_hash
      }
    )

    # transfer transaction mint
    transaction8 = insert(:transaction)

    insert(
      :transfer,
      %{
        address_from: <<0>>,
        address_to: address_hash,
        transaction_id: transaction8.id,
        contract: asset_hash,
        amount: Decimal.new("18.0")
      }
    )

    # transfer transaction burn
    transaction9 = insert(:transaction)

    insert(
      :transfer,
      %{
        address_from: address_hash,
        address_to: <<0>>,
        transaction_id: transaction9.id,
        contract: asset_hash,
        amount: Decimal.new("18.0")
      }
    )

    # pay gas fee
    transaction10 = insert(:transaction)

    insert(
      :vin,
      %{
        transaction_id: transaction10.id,
        vout_n: vout.n,
        vout_transaction_hash: vout.transaction_hash
      }
    )

    insert(
      :vout,
      %{
        address_hash: address_hash,
        transaction_id: transaction10.id,
        transaction_hash: transaction10.hash,
        asset_hash: @utility_token,
        value: Decimal.new("4.9")
      }
    )

    transaction11 = insert(:transaction, %{type: "miner_transaction"})

    insert(
      :vout,
      %{
        address_hash: address_hash,
        transaction_id: transaction11.id,
        transaction_hash: transaction11.hash,
        asset_hash: @utility_token,
        value: Decimal.new("5.0")
      }
    )

    Flush.all()

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: query,
          variables: %{
            hash: Base58.encode(address_hash),
            end_timestamp: 1_651_328_616,
            start_timestamp: 0,
            limit: 15
          }
        }
      )

    body = json_response(conn, 200)

    assert [
             %{
               "address_from" => "network_fees",
               "address_to" => address_hash_str,
               "amount" => "5",
               "asset" => Base.encode16(@utility_token, case: :lower),
               "block_height" => transaction11.block_index,
               "time" => DateTime.to_unix(transaction11.block_time),
               "txid" => Base.encode16(transaction11.hash, case: :lower)
             },
             %{
               "address_from" => address_hash_str,
               "address_to" => "fees",
               "amount" => "0.2",
               "asset" => Base.encode16(@utility_token, case: :lower),
               "block_height" => transaction10.block_index,
               "time" => DateTime.to_unix(transaction10.block_time),
               "txid" => Base.encode16(transaction10.hash, case: :lower)
             },
             %{
               "address_from" => address_hash_str,
               "address_to" => "burn",
               "amount" => "18",
               "asset" => asset_hash_str,
               "block_height" => transaction9.block_index,
               "time" => DateTime.to_unix(transaction9.block_time),
               "txid" => Base.encode16(transaction9.hash, case: :lower)
             },
             %{
               "address_from" => "mint",
               "address_to" => address_hash_str,
               "amount" => "18",
               "asset" => asset_hash_str,
               "block_height" => transaction8.block_index,
               "time" => DateTime.to_unix(transaction8.block_time),
               "txid" => Base.encode16(transaction8.hash, case: :lower)
             },
             %{
               "address_from" => address_hash_str,
               "address_to" => Base58.encode(vout7.address_hash),
               "amount" => "1",
               "asset" => asset_hash_str,
               "block_height" => transaction6.block_index,
               "time" => DateTime.to_unix(transaction6.block_time),
               "txid" => Base.encode16(transaction6.hash, case: :lower)
             },
             %{
               "address_from" => Base.encode16(transaction4.hash, case: :lower),
               "address_to" => address_hash_str,
               "amount" => "14",
               "asset" => asset_hash_str,
               "block_height" => transaction4.block_index,
               "time" => DateTime.to_unix(transaction4.block_time),
               "txid" => Base.encode16(transaction4.hash, case: :lower)
             },
             %{
               "address_from" => address_hash_str,
               "address_to" => Base58.encode(vout3.address_hash),
               "amount" => "50",
               "asset" => asset_hash_str,
               "block_height" => transaction3.block_index,
               "time" => DateTime.to_unix(transaction3.block_time),
               "txid" => Base.encode16(transaction3.hash, case: :lower)
             },
             %{
               "address_from" => Base58.encode(vout2.address_hash),
               "address_to" => address_hash_str,
               "amount" => "50",
               "asset" => asset_hash_str,
               "block_height" => transaction2.block_index,
               "time" => DateTime.to_unix(transaction2.block_time),
               "txid" => Base.encode16(transaction2.hash, case: :lower)
             },
             %{
               "address_from" => "claim",
               "address_to" => address_hash_str,
               "amount" => "5.1",
               "asset" => Base.encode16(@utility_token, case: :lower),
               "block_height" => transaction1.block_index,
               "time" => DateTime.to_unix(transaction1.block_time),
               "txid" => Base.encode16(transaction1.hash, case: :lower)
             }
           ] == body["data"]["address"]["transaction_abstracts"]

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: query,
          variables: %{
            hash: Base58.encode(address_hash),
            end_timestamp: 1_651_328_616,
            start_timestamp: DateTime.to_unix(vout.block_time),
            limit: 4
          }
        }
      )

    body = json_response(conn, 200)
    assert 4 == Enum.count(body["data"]["address"]["transaction_abstracts"])

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: query,
          variables: %{
            hash: Base58.encode(address_hash),
            end_timestamp: 0,
            start_timestamp: 0,
            limit: 4
          }
        }
      )

    body = json_response(conn, 200)
    assert 0 == Enum.count(body["data"]["address"]["transaction_abstracts"])
  end
end
