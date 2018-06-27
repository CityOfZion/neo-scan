defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Transactions

  test "get/1" do
    transaction = insert(:transaction, %{vouts: [insert(:vout)]})
    transaction2 = Transactions.get(transaction.hash)
    assert 1 == Enum.count(transaction2.vouts)
    assert transaction.hash == transaction2.hash
  end

  test "paginate/1" do
    for _ <- 1..20, do: insert(:transaction)
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
end
