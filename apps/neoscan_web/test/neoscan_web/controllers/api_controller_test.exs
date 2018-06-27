defmodule NeoscanWeb.ApiControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  setup do
    Supervisor.terminate_child(NeoscanWeb.Supervisor, ConCache)
    Supervisor.restart_child(NeoscanWeb.Supervisor, ConCache)
    :ok
  end

  #  test "get_balance/:hash", %{conn: conn} do
  #    address =
  #      insert(:address, %{
  #        balance: %{
  #          "assethash0" => %{
  #            "amount" => 50,
  #            "asset" => "assethash1"
  #          }
  #        }
  #      })
  #
  #    conn = get(conn, "/api/main_net/v1/get_balance/#{address.address}")
  #
  #    assert %{
  #             "address" => address.address,
  #             "balance" => [
  #               %{"amount" => 50, "asset" => "Asset not Found", "unspent" => []}
  #             ]
  #           } == json_response(conn, 200)
  #  end
  #
  #  test "get_claimed/:hash", %{conn: conn} do
  #    address = insert(:address)
  #    conn = get(conn, "/api/main_net/v1/get_claimed/#{address.address}")
  #
  #    assert address.address == json_response(conn, 200)["address"]
  #  end
  #
  #  test "get_unclaimed/:hash", %{conn: conn} do
  #    address = insert(:address)
  #    conn = get(conn, "/api/main_net/v1/get_unclaimed/#{address.address}")
  #
  #    assert address.address == json_response(conn, 200)["address"]
  #  end
  #
  #  test "get_claimable/:hash", %{conn: conn} do
  #    address = insert(:address)
  #    conn = get(conn, "/api/main_net/v1/get_claimable/#{address.address}")
  #
  #    assert address.address == json_response(conn, 200)["address"]
  #  end
  #
  #  test "get_address/:hash", %{conn: conn} do
  #    address = insert(:address)
  #    conn = get(conn, "/api/main_net/v1/get_address/#{address.address}")
  #
  #    assert address.address == json_response(conn, 200)["address"]
  #  end
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
  #
  #  test "get_asset/:hash", %{conn: conn} do
  #    asset = insert(:asset)
  #    conn = get(conn, "/api/main_net/v1/get_asset/#{asset.txid}")
  #
  #    assert asset.txid == json_response(conn, 200)["txid"]
  #  end
  #
  #  test "get_assets", %{conn: conn} do
  #    insert(:asset)
  #    conn = get(conn, "/api/main_net/v1/get_assets")
  #
  #    assert is_list(json_response(conn, 200))
  #  end
  #
  test "get_block/:hash", %{conn: conn} do
    block = insert(:block, %{transactions: [insert(:transaction)]})
    [%{hash: transaction_hash}] = block.transactions
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
             "tx_count" => block.tx_count,
             "version" => block.version
           } == json_response(conn, 200)
  end

  #
  #  test "get_last_blocks", %{conn: conn} do
  #    insert(:block)
  #    insert(:block)
  #    conn = get(conn, "/api/main_net/v1/get_last_blocks")
  #    assert 2 == Enum.count(json_response(conn, 200))
  #  end
  #
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
  #
  #  test "get_highest_block", %{conn: conn} do
  #    insert(:block)
  #    block2 = insert(:block)
  #    conn = get(conn, "/api/main_net/v1/get_highest_block")
  #
  #    assert block2.hash == json_response(conn, 200)["hash"]
  #  end
  #
  #  test "get_transaction/:hash", %{conn: conn} do
  #    transaction = insert(:transaction)
  #    conn = get(conn, "/api/main_net/v1/get_transaction/#{transaction.txid}")
  #
  #    assert transaction.txid == json_response(conn, 200)["txid"]
  #  end
  #
  #  test "get_last_transactions/:type", %{conn: conn} do
  #    insert(:transaction)
  #    insert(:transaction, %{type: "hello"})
  #    conn = get(conn, "/api/main_net/v1/get_last_transactions")
  #    assert 2 == Enum.count(json_response(conn, 200))
  #
  #    conn = get(conn, "/api/main_net/v1/get_last_transactions/hello")
  #    assert 1 == Enum.count(json_response(conn, 200))
  #  end
  #
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

  test "get_nodes", %{conn: conn} do
    conn = get(conn, "/api/main_net/v1/get_nodes")
    assert %{"urls" => [_ | _]} = json_response(conn, 200)
  end

  test "get_height", %{conn: conn} do
    insert(:counter, %{name: "blocks", value: 156})
    conn = get(conn, "/api/main_net/v1/get_height")
    assert 155 == json_response(conn, 200)["height"]
  end

  test "get_fees_in_range", %{conn: conn} do
    insert(:block, %{total_net_fee: 2.3, total_sys_fee: 1.4, index: 1})
    insert(:block, %{total_net_fee: 2.3, total_sys_fee: 1.4, index: 750})
    insert(:block, %{total_net_fee: 2.4, total_sys_fee: 1.5, index: 751})
    conn = get(conn, "/api/main_net/v1/get_fees_in_range/500-1000")

    assert %{"total_net_fee" => 4.699999999999999, "total_sys_fee" => 2.9} =
             json_response(conn, 200)
  end
end
