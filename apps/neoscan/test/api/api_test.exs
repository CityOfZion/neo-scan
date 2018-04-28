defmodule Neoscan.Api.ApiTest do
  use Neoscan.DataCase, async: true
  import Neoscan.Factory
  alias Neoscan.Api

  test "get_balance/1" do
    address = insert(:address)

    assert not is_nil(Api.get_balance(address.address).balance)
    assert is_nil(Api.get_balance("notexisting").balance)
  end

  test "get_unclaimed/1" do
    address = insert(:address)

    assert %{address: address.address, unclaimed: 0} == Api.get_unclaimed(address.address)
    assert %{address: "not found", unclaimed: 0} == Api.get_unclaimed("notexisting")
  end

  test "get_claimed/1" do
    address = insert(:address)
    expected_claim = [%{txids: List.first(address.claimed).txids}]

    assert %{address: address.address, claimed: expected_claim} ==
             Api.get_claimed(address.address)

    assert %{address: "not found", claimed: nil} == Api.get_claimed("notexisting")
  end

  test "get_claimable/1" do
    address = insert(:address)

    assert %{address: address.address, claimable: [], unclaimed: 0} ==
             Api.get_claimable(address.address)

    assert %{address: "not found", claimable: nil} == Api.get_claimable("notexisting")
  end

  test "get_address/1" do
    address = insert(:address)

    assert %{address: "not found", balance: nil, txids: nil, claimed: nil} ==
             Api.get_address("notexisting")

    assert 0 == Api.get_address(address.address).unclaimed
  end

  test "get_address_neon/1" do
    address = insert(:address)
    %{histories: [%{txid: txid}]} = address
    insert(:transaction, %{txid: txid})

    assert %{address: "not found", balance: nil, txids: nil, claimed: nil} ==
             Api.get_address_neon("notexisting")

    assert address.address == Api.get_address_neon(address.address).address
  end

  test "get_assets/1" do
    asset = insert(:asset)

    assert %{
             admin: nil,
             amount: nil,
             name: nil,
             owner: nil,
             precision: nil,
             txid: "not found",
             type: nil
           } == Api.get_asset("notexisting")

    asset2 = Api.get_asset(asset.txid)
    assert asset.txid == asset2.txid
  end

  test "get_block/1" do
    block = insert(:block)
    block1 = Api.get_block(block.hash)
    block2 = Api.get_block("#{block.index}")
    assert block1 == block2

    assert %{
             confirmations: nil,
             hash: "not found",
             index: nil,
             merkleroot: nil,
             nextblockhash: nil,
             nextconcensus: nil,
             nonce: nil,
             previousblockhash: nil,
             scrip: nil,
             size: nil,
             time: nil,
             transactions: nil,
             tx_count: nil,
             version: nil
           } == Api.get_block("notexisting")
  end

  test "get_last_blocks/0" do
    insert(:block)
    insert(:block)
    assert 2 == Enum.count(Api.get_last_blocks())
  end

  test "get_highest_block/0" do
    insert(:block)
    block = insert(:block)
    assert block.index == Api.get_highest_block().index
  end

  test "get_transaction/1" do
    transaction = insert(:transaction)
    assert transaction.txid == Api.get_transaction(transaction.txid).txid

    assert %{
             asset: nil,
             attributes: nil,
             block_hash: nil,
             block_height: nil,
             claims: nil,
             contract: nil,
             description: nil,
             net_fee: nil,
             nonce: nil,
             pubkey: nil,
             scripts: nil,
             size: nil,
             sys_fee: nil,
             time: nil,
             txid: "not found",
             type: nil,
             version: nil,
             vin: nil,
             vouts: nil
           } == Api.get_transaction("notexisting")
  end

  test "get_last_transactions/1" do
    insert(:transaction)
    insert(:transaction)
    assert 2 == Enum.count(Api.get_last_transactions(nil))
    assert 2 == Enum.count(Api.get_last_transactions("FactoryTransaction"))
    assert 0 == Enum.count(Api.get_last_transactions("notexisting"))
  end

  test "get_last_transactions_by_address/2" do
    transaction = insert(:transaction)
    history = insert(:history, %{txid: transaction.txid})
    transaction2 = insert(:transaction)
    insert(:history, %{address_hash: history.address_hash, txid: transaction2.txid})
    insert(:history)

    assert 2 == Enum.count(Api.get_last_transactions_by_address(history.address_hash, 1))
    assert 0 == Enum.count(Api.get_last_transactions_by_address(history.address_hash, 2))
  end

  test "get_all_nodes/0" do
    # TODO solve circular dependencies
    # Api.get_all_nodes()
  end

  test "get_fees_in_range/1" do
    block = insert(:block, %{total_net_fee: 10.0, total_sys_fee: 5.0})
    insert(:block, %{total_net_fee: 3.0, total_sys_fee: 7.0})

    assert %{total_net_fee: 13.0, total_sys_fee: 12.0} ==
             Api.get_fees_in_range("#{block.index}-1000")

    assert %{total_net_fee: 0, total_sys_fee: 0} == Api.get_fees_in_range("500-1000")
    assert "wrong input" == Api.get_fees_in_range("50022")
  end

  test "repair_blocks/0" do
    Api.repair_blocks()
  end

  test "repair_block_counter/0" do
    Api.repair_block_counter()
  end

  # TODO fix this typo, trasfer => transfer
  # TODO solve circular dependencies
  # test "repair_trasfers/0" do
  #  Api.repair_trasfers
  # end

  test "get_address_abstracts/2" do
    assert [] == Api.get_address_abstracts("not_existing", 1).entries
  end

  test "get_address_to_address_abstracts/3" do
    assert [] == Api.get_address_to_address_abstracts("not_existing", "not_existing", 1).entries
  end
end
