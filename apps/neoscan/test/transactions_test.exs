defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Transactions

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  test "get/1" do
    asset = insert(:asset)

    transaction =
      insert(:transaction, %{vouts: [insert(:vout, %{asset_hash: asset.transaction_hash})]})

    transaction2 = Transactions.get(transaction.hash)
    assert 1 == Enum.count(transaction2.vouts)
    assert transaction.hash == transaction2.hash
  end

  test "paginate/1" do
    for _ <- 1..20, do: insert(:transaction, %{type: "contract_transaction"})
    assert 15 == Enum.count(Transactions.paginate(1))
    assert 5 == Enum.count(Transactions.paginate(2))
  end

  test "get_for_block/2" do
    block = insert(:block, %{transactions: [insert(:transaction), insert(:transaction)]})
    assert 2 == Enum.count(Transactions.get_for_block(block.hash, 1))
    assert 0 == Enum.count(Transactions.get_for_block(block.hash, 2))
  end

  test "get_for_address/2" do
    transaction1 = insert(:transaction)
    transaction2 = insert(:transaction)
    address_history = insert(:address_history, %{transaction_hash: transaction1.hash})

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      transaction_hash: transaction2.hash
    })

    transactions = Transactions.get_for_address(address_history.address_hash, 1)
    assert 2 == Enum.count(transactions)
  end

  test "get_claimed_vouts/1" do
    asset = insert(:asset)
    vout1 = insert(:vout, %{asset_hash: asset.transaction_hash})
    insert(:vout, %{address_hash: vout1.address_hash, asset_hash: asset.transaction_hash})
    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: asset.transaction_hash})
    claim1 = insert(:claim, %{vout_n: vout1.n, vout_transaction_hash: vout1.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    start_block_index = vout1.start_block_index
    claim_transaction_hash = claim1.transaction_hash

    assert [
             {%{start_block_index: ^start_block_index},
              %{transaction_hash: ^claim_transaction_hash}},
             {%{}, %{}}
           ] = Transactions.get_claimed_vouts(vout1.address_hash)
  end

  test "get_unspent_vouts/1" do
    asset = insert(:asset)
    vout1 = insert(:vout, %{asset_hash: asset.transaction_hash})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: asset.transaction_hash})
    insert(:vin, %{vout_n: vout2.n, vout_transaction_hash: vout2.transaction_hash})
    insert(:vout, %{address_hash: vout1.address_hash, asset_hash: asset.transaction_hash})

    assert 2 == Enum.count(Transactions.get_unspent_vouts(vout1.address_hash))
  end

  test "get_claimable_vouts/1" do
    insert(:asset, %{transaction_hash: @neo_asset_hash})
    vout1 = insert(:vout, %{asset_hash: @neo_asset_hash})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout2.n, vout_transaction_hash: vout2.transaction_hash})
    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    transaction_hash = vout2.transaction_hash

    assert [%{transaction_hash: ^transaction_hash}] =
             Transactions.get_claimable_vouts(vout1.address_hash)
  end

  test "get_unclaimed_vouts/1" do
    insert(:asset, %{transaction_hash: @neo_asset_hash})
    vout1 = insert(:vout, %{asset_hash: @neo_asset_hash})
    vout2 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout2.n, vout_transaction_hash: vout2.transaction_hash})
    vout3 = insert(:vout, %{address_hash: vout1.address_hash, asset_hash: @neo_asset_hash})
    insert(:vin, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})
    insert(:claim, %{vout_n: vout3.n, vout_transaction_hash: vout3.transaction_hash})

    transaction_hash = vout2.transaction_hash
    transaction_hash1 = vout1.transaction_hash

    assert [%{transaction_hash: ^transaction_hash1}, %{transaction_hash: ^transaction_hash}] =
             Transactions.get_unclaimed_vouts(vout1.address_hash)
  end
end
