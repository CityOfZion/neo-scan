defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Transactions

  describe "transaction" do
    alias Neoscan.Transactions.Transaction

    def transaction_fixture(_attrs \\ %{}) do
      insert(:transaction)
    end

    test "list_transactions/0 returns all transaction" do
      transaction = insert(:transaction)
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      transaction = insert(:transaction)
      assert length(transaction.attributes) == 1
      assert transaction.net_fee == "0"
      assert transaction.nonce == 15155
      assert length(transaction.scripts) == 1
      assert transaction.size == 5
      assert transaction.sys_fee == "0"
      assert "txhash" <> _ = transaction.txid
      assert transaction.type == "FactoryTransaction"
      assert transaction.version == 1
      assert length(transaction.vin) == 1
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = insert(:transaction)
      assert {:ok, transaction} = Transactions.update_transaction(transaction, %{"nonce" => 12})
      assert transaction.nonce == 12
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = insert(:transaction)

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, %{"block_hash" => nil})

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = insert(:transaction)
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end
  end
end
