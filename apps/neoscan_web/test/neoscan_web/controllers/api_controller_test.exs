defmodule NeoscanWeb.ApiControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  setup do
    Supervisor.terminate_child(NeoscanWeb.Supervisor, ConCache)
    Supervisor.restart_child(NeoscanWeb.Supervisor, ConCache)
    :ok
  end

  test "get_balance/:hash", %{conn: conn} do
    vout1 = insert(:vout, %{asset_hash: @neo_asset_hash, value: 2.0})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout2.n, vout_transaction_hash: vout2.transaction_hash})

    vout3 =
      insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash, value: 5.0})

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:address_history, %{
      address_hash: vout1.address_hash,
      asset_hash: <<4, 5, 6>>,
      value: 2.0
    })

    insert(:asset, %{
      transaction_hash: <<4, 5, 6>>,
      name: [%{"lang" => "zh", "name" => "My Token"}]
    })

    conn = get(conn, "/api/main_net/v1/get_balance/#{Base58.encode(vout1.address_hash)}")

    assert %{
             "address" => Base58.encode(vout1.address_hash),
             "balance" => [
               %{
                 "amount" => vout3.value + vout1.value,
                 "asset" => "NEO",
                 "unspent" => [
                   %{
                     "n" => vout3.n,
                     "txid" => Base.encode16(vout3.transaction_hash, case: :lower),
                     "value" => vout3.value
                   },
                   %{
                     "n" => vout1.n,
                     "txid" => Base.encode16(vout1.transaction_hash, case: :lower),
                     "value" => vout1.value
                   }
                 ]
               },
               %{"amount" => 2.0, "asset" => "My Token", "unspent" => []}
             ]
           } == json_response(conn, 200)
  end

  test "get_claimed/:hash", %{conn: conn} do
    vout1 = insert(:vout)
    insert(:vout, %{address_hash: vout1.address_hash})
    vout3 = insert(:vout, %{address_hash: vout1.address_hash})
    vout4 = insert(:vout, %{address_hash: vout1.address_hash})
    insert(:claim, %{vout_n: vout1.n, vout_transaction_hash: vout1.transaction_hash})
    claim3 = insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    insert(:claim, %{
      transaction_hash: claim3.transaction_hash,
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash
    })

    conn = get(conn, "/api/main_net/v1/get_claimed/#{Base58.encode(vout1.address_hash)}")

    assert %{
             "address" => Base58.encode(vout1.address_hash),
             "claimed" => [
               %{
                 "txids" => [Base.encode16(vout1.transaction_hash, case: :lower)]
               },
               %{
                 "txids" => [
                   Base.encode16(vout3.transaction_hash, case: :lower),
                   Base.encode16(vout4.transaction_hash, case: :lower)
                 ]
               }
             ]
           } == json_response(conn, 200)
  end

  test "get_unclaimed/:hash", %{conn: conn} do
    :ets.insert(Neoscan.BlocksCache, {:min, nil})
    :ets.insert(Neoscan.BlocksCache, {:max, nil})
    vout1 = insert(:vout, %{start_block_index: 4, value: 5.0, asset_hash: @neo_asset_hash})

    vout2 =
      insert(:vout, %{
        address_hash: vout1.address_hash,
        start_block_index: 3,
        value: 5.0,
        asset_hash: @neo_asset_hash
      })

    insert(:vin, %{
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash,
      block_index: 6
    })

    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    insert(:block, %{index: 2, total_sys_fee: 6.0})
    insert(:block, %{index: 4, total_sys_fee: 1.0})
    insert(:block, %{index: 5, total_sys_fee: 5.0})
    insert(:block, %{index: 6, total_sys_fee: 44.0})
    insert(:block, %{index: 9, total_sys_fee: 12.0})
    insert(:block, %{index: 10, total_sys_fee: 12.0})
    insert(:block, %{index: 11, total_sys_fee: 12.0})
    insert(:block, %{index: 12, total_sys_fee: 12.0})
    insert(:block, %{index: 13, total_sys_fee: 12.0})
    insert(:block, %{index: 14, total_sys_fee: 12.0})
    # current index will be 9

    address_hash = Base58.encode(vout1.address_hash)

    conn = get(conn, "/api/main_net/v1/get_unclaimed/#{address_hash}")

    assert %{
             "address" => address_hash,
             "unclaimed" => 6.0e-6
           } == json_response(conn, 200)
  end

  test "get_claimable/:hash", %{conn: conn} do
    :ets.insert(Neoscan.BlocksCache, {:min, nil})
    :ets.insert(Neoscan.BlocksCache, {:max, nil})
    vout1 = insert(:vout, %{asset_hash: @neo_asset_hash})

    vout2 =
      insert(:vout, %{
        address_hash: vout1.address_hash,
        start_block_index: 3,
        value: 5.0,
        asset_hash: @neo_asset_hash
      })

    insert(:vin, %{
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash,
      block_index: 6
    })

    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    vout4 =
      insert(:vout, %{
        address_hash: vout1.address_hash,
        start_block_index: 5,
        value: 2.0,
        asset_hash: @neo_asset_hash
      })

    insert(:vin, %{
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash,
      block_index: 8
    })

    insert(:block, %{index: 2, gas_generated: 7.0, total_sys_fee: 6.0})
    insert(:block, %{index: 4, gas_generated: 5.0, total_sys_fee: 2.0})
    insert(:block, %{index: 5, gas_generated: 2.0, total_sys_fee: 5.0})
    insert(:block, %{index: 6, gas_generated: 4.0, total_sys_fee: 44.0})
    insert(:block, %{index: 9, gas_generated: 3.0, total_sys_fee: 12.0})

    address_hash = Base58.encode(vout1.address_hash)
    conn = get(conn, "/api/main_net/v1/get_claimable/#{address_hash}")

    assert %{
             "address" => address_hash,
             "claimable" => [
               %{
                 "end_height" => 8,
                 "generated" => 4.8e-7,
                 "n" => vout4.n,
                 "start_height" => 5,
                 "sys_fee" => 9.8e-7,
                 "txid" => Base.encode16(vout4.transaction_hash, case: :lower),
                 "unclaimed" => 1.46e-6,
                 "value" => 2
               },
               %{
                 "end_height" => 6,
                 "generated" => 1.2e-6,
                 "n" => vout2.n,
                 "start_height" => 3,
                 "sys_fee" => 3.5e-7,
                 "txid" => Base.encode16(vout2.transaction_hash, case: :lower),
                 "unclaimed" => 1.55e-6,
                 "value" => 5
               }
             ],
             "unclaimed" => 3.01e-6
           } == json_response(conn, 200)
  end

  test "get_address_neon/:hash", %{conn: conn} do
    transaction1 = insert(:transaction)
    transaction2 = insert(:transaction)
    transaction3 = insert(:transaction)
    transaction4 = insert(:transaction)
    transaction5 = insert(:transaction)
    transaction6 = insert(:transaction)
    transaction7 = insert(:transaction)
    transaction8 = insert(:transaction)
    transaction9 = insert(:transaction)
    transaction10 = insert(:transaction)

    vout1 =
      insert(:vout, %{
        transaction_hash: transaction1.hash,
        asset_hash: @neo_asset_hash,
        value: 2.0
      })

    vout2 =
      insert(:vout, %{
        transaction_hash: transaction2.hash,
        address_hash: vout1.address_hash,
        asset_hash: @neo_asset_hash
      })

    insert(:vin, %{
      transaction_hash: transaction3.hash,
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash
    })

    _vout3 =
      insert(:vout, %{
        transaction_hash: transaction4.hash,
        address_hash: vout1.address_hash,
        asset_hash: @neo_asset_hash,
        value: 5.0
      })

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    vout1 =
      insert(:vout, %{
        transaction_hash: transaction5.hash,
        asset_hash: @neo_asset_hash,
        address_hash: vout1.address_hash
      })

    insert(:vout, %{
      transaction_hash: transaction6.hash,
      asset_hash: @neo_asset_hash,
      address_hash: vout1.address_hash
    })

    vout3 =
      insert(:vout, %{
        transaction_hash: transaction7.hash,
        asset_hash: @neo_asset_hash,
        address_hash: vout1.address_hash
      })

    vout4 =
      insert(:vout, %{
        transaction_hash: transaction8.hash,
        asset_hash: @neo_asset_hash,
        address_hash: vout1.address_hash
      })

    insert(:claim, %{
      transaction_hash: transaction9.hash,
      vout_n: vout1.n,
      vout_transaction_hash: vout1.transaction_hash
    })

    claim3 =
      insert(:claim, %{
        transaction_hash: transaction10.hash,
        vout_n: vout3.n,
        vout_transaction_hash: vout3.transaction_hash
      })

    insert(:claim, %{
      transaction_hash: claim3.transaction_hash,
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash
    })

    conn = get(conn, "/api/main_net/v1/get_address_neon/#{Base58.encode(vout1.address_hash)}")
    result = json_response(conn, 200)
    assert 1 == Enum.count(result["balance"])
    assert 2 == Enum.count(result["claimed"])
    assert 8 == Enum.count(result["txids"])
  end

  test "get_address_abstracts/:hash/:page", %{conn: conn} do
    asset = insert(:asset)
    asset_hash = asset.transaction_hash
    asset_hash_str = Base.encode16(asset_hash, case: :lower)

    # claim transaction (no vin, but 1 vout) address is receiver
    transaction1 = insert(:transaction)

    vout =
      insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 5.1})

    address_hash = vout.address_hash
    address_hash_str = Base58.encode(address_hash)
    insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 2.1})
    insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 3.0})

    # normal transaction (1 vin 2 vouts) address is receiver, receive 5.0
    transaction2 = insert(:transaction)

    vout4 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction2.hash,
        asset_hash: asset_hash,
        value: 5.0
      })

    vout2 = insert(:vout, %{asset_hash: asset_hash, value: 7.0})

    insert(:vin, %{
      transaction_hash: transaction2.hash,
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash
    })

    insert(:vout, %{transaction_hash: transaction2.hash, asset_hash: asset_hash, value: 2.0})

    # normal transaction address is sender
    transaction3 = insert(:transaction)

    vout3 =
      insert(:vout, %{transaction_hash: transaction3.hash, asset_hash: asset_hash, value: 5.0})

    insert(:vin, %{
      transaction_hash: transaction3.hash,
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash
    })

    # multi transaction (2 vins 1 vout)
    transaction5 = insert(:transaction)

    vout5 =
      insert(:vout, %{transaction_hash: transaction5.hash, asset_hash: asset_hash, value: 9.0})

    transaction4 = insert(:transaction)

    vout6 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction4.hash,
        asset_hash: asset_hash,
        value: 14.0
      })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout3.n,
      vout_transaction_hash: vout3.transaction_hash
    })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout5.n,
      vout_transaction_hash: vout5.transaction_hash
    })

    # multi transaction (1 vin 2 vouts) where vin has the same address hash than 1 vout
    transaction6 = insert(:transaction)

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction6.hash,
      asset_hash: asset_hash,
      value: 13.0
    })

    vout7 =
      insert(:vout, %{transaction_hash: transaction6.hash, asset_hash: asset_hash, value: 1.0})

    insert(:vin, %{
      transaction_hash: transaction6.hash,
      vout_n: vout6.n,
      vout_transaction_hash: vout6.transaction_hash
    })

    conn = get(conn, "/api/main_net/v1/get_address_abstracts/#{address_hash_str}/1")

    assert [
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
               "amount" => "5",
               "asset" => asset_hash_str,
               "block_height" => transaction3.block_index,
               "time" => DateTime.to_unix(transaction3.block_time),
               "txid" => Base.encode16(transaction3.hash, case: :lower)
             },
             %{
               "address_from" => Base58.encode(vout2.address_hash),
               "address_to" => address_hash_str,
               "amount" => "5",
               "asset" => asset_hash_str,
               "block_height" => transaction2.block_index,
               "time" => DateTime.to_unix(transaction2.block_time),
               "txid" => Base.encode16(transaction2.hash, case: :lower)
             },
             %{
               "address_from" => "claim",
               "address_to" => address_hash_str,
               "amount" => "5.1",
               "asset" => asset_hash_str,
               "block_height" => transaction1.block_index,
               "time" => DateTime.to_unix(transaction1.block_time),
               "txid" => Base.encode16(transaction1.hash, case: :lower)
             }
           ] == json_response(conn, 200)["entries"]
  end

  test "get_address_to_address_abstracts/:hash1/:hash2/:page", %{conn: conn} do
    asset = insert(:asset)
    asset_hash = asset.transaction_hash
    asset_hash_str = Base.encode16(asset_hash, case: :lower)

    # send 5 from an address to another
    transaction1 = insert(:transaction)
    transaction2 = insert(:transaction)

    vout2 =
      insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 5.0})

    vout1 =
      insert(:vout, %{transaction_hash: transaction2.hash, asset_hash: asset_hash, value: 5.0})

    address_hash_str = Base58.encode(vout1.address_hash)
    address_hash_str2 = Base58.encode(vout2.address_hash)

    insert(:vin, %{
      transaction_hash: transaction1.hash,
      vout_n: vout1.n,
      vout_transaction_hash: vout1.transaction_hash
    })

    # send it back

    transaction3 = insert(:transaction)

    insert(:vout, %{
      address_hash: vout1.address_hash,
      transaction_hash: transaction3.hash,
      asset_hash: asset_hash,
      value: 5.0
    })

    insert(:vin, %{
      transaction_hash: transaction3.hash,
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash
    })

    conn =
      get(
        conn,
        "/api/main_net/v1/get_address_to_address_abstracts/#{address_hash_str}/#{
          address_hash_str2
        }/1"
      )

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
  end

  test "get_block/:hash", %{conn: conn} do
    block = insert(:block, %{transactions: [insert(:transaction)]})
    [%{hash: transaction_hash}] = block.transactions
    transfer = insert(:transfer, %{block_index: block.index})
    conn = get(conn, "/api/main_net/v1/get_block/#{Base.encode16(block.hash)}")

    assert %{
             "confirmations" => 1,
             "hash" => Base.encode16(block.hash, case: :lower),
             "index" => block.index,
             "merkleroot" => Base.encode16(block.merkle_root, case: :lower),
             "nextblockhash" => "",
             "nextconsensus" => Base.encode16(block.next_consensus, case: :lower),
             "nonce" => Base.encode16(block.nonce, case: :lower),
             "previousblockhash" => "",
             "script" => block.script,
             "size" => block.size,
             "time" => DateTime.to_unix(block.time),
             "transactions" => [Base.encode16(transaction_hash, case: :lower)],
             "transfers" => [Base.encode16(transfer.transaction_hash, case: :lower)],
             "tx_count" => block.tx_count,
             "version" => block.version
           } == json_response(conn, 200)
  end

  test "test concache", %{conn: conn} do
    asset = insert(:asset)
    transaction = insert(:transaction)

    vout =
      insert(:vout, %{transaction_hash: transaction.hash, asset_hash: asset.transaction_hash})

    transaction = insert(:transaction)

    insert(:vout, %{
      transaction_hash: transaction.hash,
      address_hash: vout.address_hash,
      asset_hash: asset.transaction_hash
    })

    address_hash = Base58.encode(vout.address_hash)
    conn = get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{address_hash}/1")
    assert 2 == Enum.count(json_response(conn, 200))
    transaction = insert(:transaction)

    insert(:vout, %{
      transaction_hash: transaction.hash,
      address_hash: vout.address_hash,
      asset_hash: asset.transaction_hash
    })

    conn = get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{address_hash}/1")
    assert 2 == Enum.count(json_response(conn, 200))
    Supervisor.terminate_child(NeoscanWeb.Supervisor, ConCache)
    Supervisor.restart_child(NeoscanWeb.Supervisor, ConCache)
    conn = get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{address_hash}/1")
    assert 3 == Enum.count(json_response(conn, 200))
  end

  test "get_transaction/:hash", %{conn: conn} do
    asset = insert(:asset)
    transaction = insert(:transaction)
    vout = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(:vin, %{
      transaction_hash: transaction.hash,
      vout_n: vout.n,
      vout_transaction_hash: vout.transaction_hash
    })

    vout2 =
      insert(:vout, %{transaction_hash: transaction.hash, asset_hash: asset.transaction_hash})

    vout3 = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(:claim, %{
      transaction_hash: transaction.hash,
      vout_n: vout3.n,
      vout_transaction_hash: vout3.transaction_hash
    })

    conn =
      get(
        conn,
        "/api/main_net/v1/get_transaction/#{Base.encode16(transaction.hash, case: :lower)}"
      )

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
                 "value" => vout3.value
               }
             ],
             "contract" => nil,
             "description" => nil,
             "net_fee" => transaction.net_fee,
             "nonce" => nil,
             "pubkey" => nil,
             "scripts" => [],
             "size" => transaction.size,
             "sys_fee" => transaction.sys_fee,
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
                 "value" => vout.value
               }
             ],
             "vouts" => [
               %{
                 "address_hash" => Base58.encode(vout2.address_hash),
                 "asset" => "truc",
                 "n" => vout2.n,
                 "txid" => Base.encode16(vout2.transaction_hash, case: :lower),
                 "value" => vout2.value
               }
             ]
           } == json_response(conn, 200)
  end

  test "get_last_transactions_by_address/:hash/:page", %{conn: conn} do
    asset = insert(:asset)
    transaction = insert(:transaction)
    vout = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(:vin, %{
      transaction_hash: transaction.hash,
      vout_n: vout.n,
      vout_transaction_hash: vout.transaction_hash
    })

    _vout2 =
      insert(:vout, %{transaction_hash: transaction.hash, asset_hash: asset.transaction_hash})

    vout3 = insert(:vout, %{asset_hash: asset.transaction_hash})

    insert(:claim, %{
      transaction_hash: transaction.hash,
      vout_n: vout3.n,
      vout_transaction_hash: vout3.transaction_hash
    })

    address_hash = Base58.encode(vout.address_hash)

    conn = get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{address_hash}/1")

    assert 1 == Enum.count(json_response(conn, 200))
  end

  test "get_all_nodes", %{conn: conn} do
    conn = get(conn, "/api/main_net/v1/get_all_nodes")
    assert [%{"height" => _, "url" => _} | _] = json_response(conn, 200)
  end

  test "get_height", %{conn: conn} do
    insert(:counter, %{name: "blocks", value: 156})
    conn = get(conn, "/api/main_net/v1/get_height")
    assert 155 == json_response(conn, 200)["height"]
  end
end
