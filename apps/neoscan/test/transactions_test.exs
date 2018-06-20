defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Transactions

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
