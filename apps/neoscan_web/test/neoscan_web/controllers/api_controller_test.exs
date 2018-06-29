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
    vout1 = insert(:vout, %{start_block_index: 4, value: 5.0})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, start_block_index: 3, value: 5.0})

    insert(:vin, %{
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash,
      block_index: 6
    })

    vout3 = insert(:vout, %{address_hash: vout1.address_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    insert(:block, %{index: 2, gas_generated: 7.0, total_sys_fee: 6.8})
    insert(:block, %{index: 4, gas_generated: 5.0, total_sys_fee: 1.9})
    insert(:block, %{index: 5, gas_generated: 2.0, total_sys_fee: 5.0})
    insert(:block, %{index: 6, gas_generated: 4.0, total_sys_fee: 44.2})
    insert(:block, %{index: 9, gas_generated: 3.0, total_sys_fee: 12.0})
    insert(:block, %{index: 10, gas_generated: 3.0, total_sys_fee: 12.0})
    insert(:block, %{index: 11, gas_generated: 3.0, total_sys_fee: 12.0})
    insert(:block, %{index: 12, gas_generated: 3.0, total_sys_fee: 12.0})
    insert(:block, %{index: 13, gas_generated: 3.0, total_sys_fee: 12.0})
    insert(:block, %{index: 14, gas_generated: 3.0, total_sys_fee: 12.0})
    # current index will be 9

    address_hash = Base58.encode(vout1.address_hash)

    conn = get(conn, "/api/main_net/v1/get_unclaimed/#{address_hash}")

    assert %{
             "address" => address_hash,
             "unclaimed" => 3.9e-6
           } == json_response(conn, 200)
  end

  test "get_claimable/:hash", %{conn: conn} do
    vout1 = insert(:vout)
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, start_block_index: 3, value: 5.0})

    insert(:vin, %{
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash,
      block_index: 6
    })

    vout3 = insert(:vout, %{address_hash: vout1.address_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    vout4 = insert(:vout, %{address_hash: vout1.address_hash, start_block_index: 5, value: 2.0})

    insert(:vin, %{
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash,
      block_index: 8
    })

    insert(:block, %{index: 2, gas_generated: 7.0, total_sys_fee: 6.8})
    insert(:block, %{index: 4, gas_generated: 5.0, total_sys_fee: 1.9})
    insert(:block, %{index: 5, gas_generated: 2.0, total_sys_fee: 5.0})
    insert(:block, %{index: 6, gas_generated: 4.0, total_sys_fee: 44.2})
    insert(:block, %{index: 9, gas_generated: 3.0, total_sys_fee: 12.0})

    address_hash = Base58.encode(vout1.address_hash)
    conn = get(conn, "/api/main_net/v1/get_claimable/#{address_hash}")

    assert %{
             "address" => address_hash,
             "claimable" => [
               %{
                 "end_height" => 8,
                 "generated" => 8.0e-8,
                 "n" => vout4.n,
                 "start_height" => 5,
                 "sys_fee" => 9.84e-7,
                 "txid" => Base.encode16(vout4.transaction_hash, case: :lower),
                 "unclaimed" => 1.064e-6,
                 "value" => 2
               },
               %{
                 "end_height" => 6,
                 "generated" => 5.5e-7,
                 "n" => vout2.n,
                 "start_height" => 3,
                 "sys_fee" => 3.45e-7,
                 "txid" => Base.encode16(vout2.transaction_hash, case: :lower),
                 "unclaimed" => 8.95e-7,
                 "value" => 5
               }
             ],
             "unclaimed" => 1.9590000000000002e-6
           } == json_response(conn, 200)
  end

  #
  #  test "get_address_neon/:hash", %{conn: conn} do
  #    address = insert(:address)
  #    %{histories: [%{txid: txid}]} = address
  #    insert(:transaction, %{txid: txid})
  #
  #    conn = get(conn, "/api/main_net/v1/get_address_neon/#{address.address}")
  #    assert address.address == json_response(conn, 200)["address"]
  #  end
  #
  #  test "get_address_abstracts/:hash/:page", %{conn: conn} do
  #    address = insert(:address)
  #    insert(:tx_abstract, %{address_from: address.address})
  #    insert(:tx_abstract, %{address_from: address.address})
  #
  #    conn = get(conn, "/api/main_net/v1/get_address_abstracts/#{address.address}/1")
  #    assert 2 == Enum.count(json_response(conn, 200)["entries"])
  #  end
  #
  #  test "get_address_to_address_abstracts/:hash1/:hash2/:page", %{conn: conn} do
  #    address1 = insert(:address)
  #    address2 = insert(:address)
  #    insert(:tx_abstract, %{address_from: address1.address, address_to: address2.address})
  #    insert(:tx_abstract, %{address_from: address2.address, address_to: address1.address})
  #
  #    conn =
  #      get(
  #        conn,
  #        "/api/main_net/v1/get_address_to_address_abstracts/#{address1.address}/#{address2.address}/1"
  #      )
  #
  #    assert 2 == Enum.count(json_response(conn, 200)["entries"])
  #  end

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

  #  test "test concache", %{conn: conn} do
  #    insert(:block)
  #    insert(:block)
  #    conn = get(conn, "/api/main_net/v1/get_last_blocks")
  #    assert 2 == Enum.count(json_response(conn, 200))
  #    insert(:block)
  #    conn = get(conn, "/api/main_net/v1/get_last_blocks")
  #    assert 2 == Enum.count(json_response(conn, 200))
  #    Supervisor.terminate_child(NeoscanWeb.Supervisor, ConCache)
  #    Supervisor.restart_child(NeoscanWeb.Supervisor, ConCache)
  #    conn = get(conn, "/api/main_net/v1/get_last_blocks")
  #    assert 3 == Enum.count(json_response(conn, 200))
  #  end

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

  #  test "get_last_transactions_by_address/:hash/:page", %{conn: conn} do
  #    transaction = insert(:transaction)
  #    history = insert(:history, %{txid: transaction.txid})
  #    transaction2 = insert(:transaction)
  #    insert(:history, %{address_hash: history.address_hash, txid: transaction2.txid})
  #    insert(:history)
  #
  #    conn =
  #      get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{history.address_hash}/1")
  #
  #    assert 2 == Enum.count(json_response(conn, 200))
  #
  #    conn =
  #      get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{history.address_hash}/2")
  #
  #    assert 0 == Enum.count(json_response(conn, 200))
  #    conn = get(conn, "/api/main_net/v1/get_last_transactions_by_address/#{history.address_hash}")
  #    assert 2 == Enum.count(json_response(conn, 200))
  #  end
  #
  test "get_all_nodes", %{conn: conn} do
    conn = get(conn, "/api/main_net/v1/get_all_nodes")
    assert [%{"height" => _, "url" => _} | _] = json_response(conn, 200)
  end

  test "get_height", %{conn: conn} do
    insert(:counter_cached, %{name: "blocks", value: 156})
    conn = get(conn, "/api/main_net/v1/get_height")
    assert 155 == json_response(conn, 200)["height"]
  end
end
