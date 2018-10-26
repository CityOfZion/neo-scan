defmodule NeoscanWeb.ApiControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory
  alias Neoscan.Flush

  @governing_token Application.fetch_env!(:neoscan, :governing_token)
  @utility_token Application.fetch_env!(:neoscan, :utility_token)

  setup do
    Supervisor.terminate_child(NeoscanWeb.Supervisor, ConCache)
    Supervisor.restart_child(NeoscanWeb.Supervisor, ConCache)
    :ok
  end

  test "get_balance/:address", %{conn: conn} do
    vout1 = insert(:vout, %{asset_hash: @governing_token, value: Decimal.new("2.0")})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    insert(:vin, %{vout_n: vout2.n, vout_transaction_hash: vout2.transaction_hash})

    vout3 =
      insert(
        :vout,
        %{
          address_hash: vout1.address_hash,
          asset_hash: @governing_token,
          value: Decimal.new("5.0")
        }
      )

    insert(
      :asset,
      %{
        transaction_hash: @governing_token,
        name: %{
          "en" => "NEO"
        }
      }
    )

    insert(
      :address_history,
      %{
        address_hash: vout1.address_hash,
        asset_hash: <<4, 5, 6>>,
        value: Decimal.new("2.0")
      }
    )

    insert(
      :asset,
      %{
        transaction_hash: <<4, 5, 6>>,
        name: %{
          "zh" => "My Token"
        },
        symbol: "TKN"
      }
    )

    Flush.all()

    conn =
      get(conn, api_path(conn, :get_balance, Base58.encode(vout1.address_hash)))
      |> BlueBird.ConnLogger.save()

    address_hash_b58 = Base58.encode(vout1.address_hash)

    amount =
      Decimal.add(vout3.value, vout1.value)
      |> Decimal.to_float()

    assert %{
             "address" => ^address_hash_b58,
             "balance" => [
               %{
                 "amount" => ^amount,
                 "asset" => "NEO",
                 "asset_hash" =>
                   "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
                 "asset_symbol" => "NEO",
                 "unspent" => unspent
               },
               %{
                 "amount" => 2.0,
                 "asset" => "My Token",
                 "asset_hash" => "040506",
                 "asset_symbol" => "TKN",
                 "unspent" => []
               }
             ]
           } = json_response(conn, 200)

    assert [
             %{
               "n" => vout3.n,
               "txid" => Base.encode16(vout3.transaction_hash, case: :lower),
               "value" =>
                 vout3.value
                 |> Decimal.to_float()
             },
             %{
               "n" => vout1.n,
               "txid" => Base.encode16(vout1.transaction_hash, case: :lower),
               "value" =>
                 vout1.value
                 |> Decimal.to_float()
             }
           ] == Enum.sort_by(unspent, &(-&1["value"]))

    conn =
      get(conn, api_path(conn, :get_balance, "==#$%"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["address is not a valid base58"]} == json_response(conn, 400)
  end

  test "get_claimed/:address", %{conn: conn} do
    insert(
      :asset,
      %{
        transaction_hash: @governing_token,
        name: %{
          "en" => "NEO"
        }
      }
    )

    vout1 = insert(:vout, %{asset_hash: @governing_token})
    insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    vout4 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    insert(:claim, %{vout_n: vout1.n, vout_transaction_hash: vout1.transaction_hash})
    claim3 = insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    insert(
      :claim,
      %{
        transaction_id: claim3.transaction_id,
        vout_n: vout4.n,
        vout_transaction_hash: vout4.transaction_hash
      }
    )

    Flush.all()

    conn =
      get(conn, api_path(conn, :get_claimed, Base58.encode(vout1.address_hash)))
      |> BlueBird.ConnLogger.save()

    address_hash = Base58.encode(vout1.address_hash)
    vout1_transaction_hash = Base.encode16(vout1.transaction_hash, case: :lower)

    assert %{
             "address" => ^address_hash,
             "claimed" => claimed
           } = json_response(conn, 200)

    assert [
             %{
               "txids" => [^vout1_transaction_hash]
             },
             %{
               "txids" => txids
             }
           ] = Enum.sort_by(claimed, &Enum.count(&1["txids"]))

    assert Base.encode16(vout3.transaction_hash, case: :lower) in txids
    assert Base.encode16(vout4.transaction_hash, case: :lower) in txids

    conn =
      get(conn, api_path(conn, :get_claimed, "==#$%"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["address is not a valid base58"]} == json_response(conn, 400)
  end

  test "get_unclaimed/:hash", %{conn: conn} do
    insert(
      :asset,
      %{
        transaction_hash: @governing_token,
        name: %{
          "en" => "NEO"
        }
      }
    )

    vout1 = insert(:vout, %{start_block_index: 4, value: 5.0, asset_hash: @governing_token})

    vout2 =
      insert(
        :vout,
        %{
          address_hash: vout1.address_hash,
          start_block_index: 3,
          value: Decimal.new("5.0"),
          asset_hash: @governing_token
        }
      )

    insert(
      :vin,
      %{
        vout_n: vout2.n,
        vout_transaction_hash: vout2.transaction_hash,
        block_index: 6
      }
    )

    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    insert(:block, %{index: 2, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 4, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 5, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 6, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 9, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 10, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 11, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 12, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 13, total_sys_fee: Decimal.new("0.0")})
    insert(:block, %{index: 14, total_sys_fee: Decimal.new("0.0")})
    # current index will be 9

    Flush.all()

    address_hash = Base58.encode(vout1.address_hash)

    conn =
      get(conn, api_path(conn, :get_unclaimed, address_hash))
      |> BlueBird.ConnLogger.save()

    assert %{
             "address" => address_hash,
             "unclaimed" => 3.2e-6
           } == json_response(conn, 200)

    conn =
      get(conn, api_path(conn, :get_unclaimed, "==#$%"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["address is not a valid base58"]} == json_response(conn, 400)
  end

  test "get_claimable/:hash", %{conn: conn} do
    insert(
      :asset,
      %{
        transaction_hash: @governing_token,
        name: %{
          "en" => "NEO"
        }
      }
    )

    vout1 = insert(:vout, %{asset_hash: @governing_token})

    vout2 =
      insert(
        :vout,
        %{
          address_hash: vout1.address_hash,
          start_block_index: 3,
          value: Decimal.new("5.0"),
          asset_hash: @governing_token
        }
      )

    insert(
      :vin,
      %{
        vout_n: vout2.n,
        vout_transaction_hash: vout2.transaction_hash,
        block_index: 6
      }
    )

    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @governing_token})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    vout4 =
      insert(
        :vout,
        %{
          address_hash: vout1.address_hash,
          start_block_index: 5,
          value: Decimal.new("2.0"),
          asset_hash: @governing_token
        }
      )

    insert(
      :vin,
      %{
        vout_n: vout4.n,
        vout_transaction_hash: vout4.transaction_hash,
        block_index: 8
      }
    )

    insert(:block, %{index: 0, total_sys_fee: Decimal.new("1.0")})
    insert(:block, %{index: 1, total_sys_fee: Decimal.new("2.0")})
    insert(:block, %{index: 2, total_sys_fee: Decimal.new("3.0")})
    insert(:block, %{index: 3, total_sys_fee: Decimal.new("4.0")})
    insert(:block, %{index: 4, total_sys_fee: Decimal.new("5.0")})
    insert(:block, %{index: 5, total_sys_fee: Decimal.new("6.0")})
    insert(:block, %{index: 6, total_sys_fee: Decimal.new("7.0")})
    insert(:block, %{index: 7, total_sys_fee: Decimal.new("8.0")})
    insert(:block, %{index: 8, total_sys_fee: Decimal.new("9.0")})
    insert(:block, %{index: 9, total_sys_fee: Decimal.new("10.0")})

    Flush.all()

    address_hash = Base58.encode(vout1.address_hash)

    conn =
      get(conn, api_path(conn, :get_claimable, address_hash))
      |> BlueBird.ConnLogger.save()

    assert %{
             "address" => address_hash,
             "claimable" => claimable,
             "unclaimed" => 2.85e-6
           } = json_response(conn, 200)

    assert [
             %{
               "end_height" => 8,
               "generated" => 4.8e-7,
               "n" => vout4.n,
               "start_height" => 5,
               "sys_fee" => 4.2e-7,
               "txid" => Base.encode16(vout4.transaction_hash, case: :lower),
               "unclaimed" => 9.0e-7,
               "value" => 2
             },
             %{
               "end_height" => 6,
               "generated" => 1.2e-6,
               "n" => vout2.n,
               "start_height" => 3,
               "sys_fee" => 7.5e-7,
               "txid" => Base.encode16(vout2.transaction_hash, case: :lower),
               "unclaimed" => 1.95e-6,
               "value" => 5
             }
           ] == Enum.sort_by(claimable, & &1["value"])

    conn =
      get(conn, api_path(conn, :get_claimable, "==#$%"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["address is not a valid base58"]} == json_response(conn, 400)
  end

  test "get_address_abstracts/:hash/:page", %{conn: conn} do
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
      get(conn, api_path(conn, :get_address_abstracts, address_hash_str, "1"))
      |> BlueBird.ConnLogger.save()

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
           ] == json_response(conn, 200)["entries"]

    conn =
      get(conn, api_path(conn, :get_address_abstracts, "==#$%", "nan"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["page is not a valid integer", "address is not a valid base58"]} ==
             json_response(conn, 400)
  end

  test "get_address_to_address_abstracts/:address1/:address2/:page", %{conn: conn} do
    asset = insert(:asset)
    asset_hash = asset.transaction_hash
    asset_hash_str = Base.encode16(asset_hash, case: :lower)

    # send 5 from an address to another
    transaction1 = insert(:transaction)
    transaction2 = insert(:transaction)

    vout2 =
      insert(
        :vout,
        %{
          transaction_hash: transaction1.hash,
          transaction_id: transaction1.id,
          asset_hash: asset_hash,
          value: Decimal.new("5.0")
        }
      )

    vout1 =
      insert(
        :vout,
        %{
          transaction_hash: transaction2.hash,
          transaction_id: transaction2.id,
          asset_hash: asset_hash,
          value: Decimal.new("5.0")
        }
      )

    address_hash_str = Base58.encode(vout1.address_hash)
    address_hash_str2 = Base58.encode(vout2.address_hash)

    insert(
      :vin,
      %{
        transaction_id: transaction1.id,
        vout_n: vout1.n,
        vout_transaction_hash: vout1.transaction_hash
      }
    )

    # send it back

    transaction3 = insert(:transaction)

    insert(
      :vout,
      %{
        address_hash: vout1.address_hash,
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
        vout_n: vout2.n,
        vout_transaction_hash: vout2.transaction_hash
      }
    )

    Flush.all()

    conn =
      get(
        conn,
        api_path(
          conn,
          :get_address_to_address_abstracts,
          address_hash_str,
          address_hash_str2,
          "1"
        )
      )
      |> BlueBird.ConnLogger.save()

    assert [
             %{
               "address_from" => address_hash_str2,
               "address_to" => address_hash_str,
               "amount" => "5",
               "asset" => asset_hash_str,
               "block_height" => transaction3.block_index,
               "time" => DateTime.to_unix(transaction3.block_time),
               "txid" => Base.encode16(transaction3.hash, case: :lower)
             },
             %{
               "address_from" => address_hash_str,
               "address_to" => address_hash_str2,
               "amount" => "5",
               "asset" => asset_hash_str,
               "block_height" => transaction1.block_index,
               "time" => DateTime.to_unix(transaction1.block_time),
               "txid" => Base.encode16(transaction1.hash, case: :lower)
             }
           ] == json_response(conn, 200)["entries"]

    conn =
      get(conn, api_path(conn, :get_address_to_address_abstracts, "==#$%", "==#$%", "nan"))
      |> BlueBird.ConnLogger.save()

    assert %{
             "errors" => [
               "page is not a valid integer",
               "address2 is not a valid base58",
               "address1 is not a valid base58"
             ]
           } == json_response(conn, 400)
  end

  test "get_block/:hash", %{conn: conn} do
    block = insert(:block, %{transactions: [insert(:transaction)]})
    [%{id: transaction_id, hash: transaction_hash}] = block.transactions
    insert(:transfer, %{block_index: block.index, transaction_id: transaction_id})

    conn =
      get(conn, api_path(conn, :get_block, Base.encode16(block.hash)))
      |> BlueBird.ConnLogger.save()

    script = %{
      "id" => block.script.id,
      "invocation" => block.script.invocation,
      "verification" => nil
    }

    assert %{
             "confirmations" => 1,
             "hash" => Base.encode16(block.hash, case: :lower),
             "index" => block.index,
             "merkleroot" => Base.encode16(block.merkle_root, case: :lower),
             "nextblockhash" => "",
             "nextconsensus" => Base.encode16(block.next_consensus, case: :lower),
             "nonce" => Base.encode16(block.nonce, case: :lower),
             "previousblockhash" => "",
             "script" => script,
             "size" => block.size,
             "time" => DateTime.to_unix(block.time),
             "transactions" => [Base.encode16(transaction_hash, case: :lower)],
             "transfers" => [Base.encode16(transaction_hash, case: :lower)],
             "tx_count" => block.tx_count,
             "version" => block.version
           } == json_response(conn, 200)

    conn =
      get(conn, api_path(conn, :get_block, Base.encode16("notfound")))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["object not found"]} == json_response(conn, 404)

    conn =
      get(conn, api_path(conn, :get_block, "nan"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["block_hash is not a valid integer_or_base16"]} ==
             json_response(conn, 400)
  end

  test "get_transaction/:hash", %{conn: conn} do
    asset = insert(:asset)
    transaction = insert(:transaction)
    vout = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(
      :vin,
      %{
        transaction_id: transaction.id,
        vout_n: vout.n,
        vout_transaction_hash: vout.transaction_hash
      }
    )

    vout2 =
      insert(
        :vout,
        %{
          transaction_id: transaction.id,
          transaction_hash: transaction.hash,
          asset_hash: asset.transaction_hash
        }
      )

    vout3 = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(
      :claim,
      %{
        transaction_id: transaction.id,
        vout_n: vout3.n,
        vout_transaction_hash: vout3.transaction_hash
      }
    )

    conn =
      get(
        conn,
        api_path(conn, :get_transaction, Base.encode16(transaction.hash, case: :lower))
      )
      |> BlueBird.ConnLogger.save()

    assert %{
             "asset" => nil,
             "attributes" => [],
             "block_hash" => Base.encode16(transaction.block_hash, case: :lower),
             "block_height" => transaction.block_index,
             "claims" => [
               %{
                 "address_hash" => Base58.encode(vout3.address_hash),
                 "asset" => Base.encode16(vout3.asset_hash, case: :lower),
                 "n" => vout3.n,
                 "txid" => Base.encode16(vout3.transaction_hash, case: :lower),
                 "value" => Decimal.to_float(vout3.value)
               }
             ],
             "contract" => nil,
             "description" => nil,
             "net_fee" => Decimal.to_float(transaction.net_fee),
             "nonce" => nil,
             "pubkey" => nil,
             "scripts" => [],
             "size" => transaction.size,
             "sys_fee" => Decimal.to_float(transaction.sys_fee),
             "time" => DateTime.to_unix(transaction.block_time),
             "txid" => Base.encode16(transaction.hash, case: :lower),
             "type" => Macro.camelize(transaction.type),
             "version" => transaction.version,
             "vin" => [
               %{
                 "address_hash" => Base58.encode(vout.address_hash),
                 "asset" => "truc",
                 "n" => vout.n,
                 "txid" => Base.encode16(vout.transaction_hash, case: :lower),
                 "value" => Decimal.to_float(vout.value)
               }
             ],
             "vouts" => [
               %{
                 "address_hash" => Base58.encode(vout2.address_hash),
                 "asset" => "truc",
                 "n" => vout2.n,
                 "txid" => Base.encode16(vout2.transaction_hash, case: :lower),
                 "value" => Decimal.to_float(vout2.value)
               }
             ]
           } == json_response(conn, 200)

    conn =
      get(conn, api_path(conn, :get_transaction, Base.encode16("notfound")))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["object not found"]} == json_response(conn, 404)

    conn =
      get(conn, api_path(conn, :get_transaction, "nan"))
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["transaction_hash is not a valid base16"]} == json_response(conn, 400)
  end

  test "get_last_transactions_by_address/:address/:page", %{conn: conn} do
    asset = insert(:asset)

    transaction =
      insert(
        :transaction,
        %{
          extra: %{
            attributes: [%{"data" => "6e656f2d6f6e65", "usage" => "Remark15"}],
            scripts: [
              %{
                "invocation" =>
                  "407e4305984ec8b7563c9815976e1e5c40347adeb71e3a9fe772253f35cdff42825afac3e39dc88ee7e7728c1f56d2941e998cb95608f946d3a22f4ac1fb0b9034",
                "verification" =>
                  "21021cdb84434d21cd0500d0a2e6f3305e78791cf33b56627f2a43a129a29d9d6920ac"
              }
            ]
          }
        }
      )

    vout = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(
      :vin,
      %{
        transaction_id: transaction.id,
        vout_n: vout.n,
        vout_transaction_hash: vout.transaction_hash
      }
    )

    _vout2 =
      insert(
        :vout,
        %{
          transaction_id: transaction.id,
          transaction_hash: transaction.hash,
          asset_hash: asset.transaction_hash
        }
      )

    vout3 = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(
      :claim,
      %{
        transaction_id: transaction.id,
        vout_n: vout3.n,
        vout_transaction_hash: vout3.transaction_hash
      }
    )

    Flush.all()

    address_hash = Base58.encode(vout.address_hash)

    conn =
      get(conn, api_path(conn, :get_last_transactions_by_address, address_hash) <> "/1")
      |> BlueBird.ConnLogger.save()

    response = json_response(conn, 200)

    assert 1 == Enum.count(response)
    assert [%{"data" => "6e656f2d6f6e65", "usage" => "Remark15"}] == hd(response)["attributes"]

    conn = get(conn, api_path(conn, :get_last_transactions_by_address, address_hash))

    assert 1 == Enum.count(json_response(conn, 200))

    conn =
      get(conn, api_path(conn, :get_last_transactions_by_address, "==") <> "/nan")
      |> BlueBird.ConnLogger.save()

    assert %{"errors" => ["page is not a valid integer", "address is not a valid base58"]} ==
             json_response(conn, 400)
  end

  test "test_net rewriting", %{conn: conn} do
    main_net_url = api_path(conn, :get_all_nodes)
    test_net_url = String.replace(main_net_url, "main_net", "test_net")
    conn = get(conn, test_net_url)
    assert [%{"height" => _, "url" => _} | _] = json_response(conn, 200)
  end

  test "get_all_nodes", %{conn: conn} do
    conn =
      get(conn, api_path(conn, :get_all_nodes))
      |> BlueBird.ConnLogger.save()

    assert [%{"height" => _, "url" => _} | _] = json_response(conn, 200)
  end

  test "get_height", %{conn: conn} do
    insert(:block_meta, %{id: 1, index: 155})

    conn =
      get(conn, api_path(conn, :get_height))
      |> BlueBird.ConnLogger.save()

    assert 155 == json_response(conn, 200)["height"]
  end
end
