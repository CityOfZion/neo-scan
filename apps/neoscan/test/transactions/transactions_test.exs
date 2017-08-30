defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase

  alias Neoscan.Transactions

  describe "transaction" do
    alias Neoscan.Transactions.Transaction

    @valid_attrs %{attributes: [], net_fee: "some net_fee", nonce: 42, scripts: [], size: 42, sys_fee: "some sys_fee", txid: "some txid", type: "some type", version: "some version", vin: [], vout: []}
    @update_attrs %{attributes: [], net_fee: "some updated net_fee", nonce: 43, scripts: [], size: 43, sys_fee: "some updated sys_fee", txid: "some updated txid", type: "some updated type", version: "some updated version", vin: [], vout: []}
    @invalid_attrs %{attributes: nil, net_fee: nil, nonce: nil, scripts: nil, size: nil, sys_fee: nil, txid: nil, type: nil, version: nil, vin: nil, vout: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transaction/0 returns all transaction" do
      transaction = transaction_fixture()
      assert Transactions.list_transaction() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction.attributes == []
      assert transaction.net_fee == "some net_fee"
      assert transaction.nonce == 42
      assert transaction.scripts == []
      assert transaction.size == 42
      assert transaction.sys_fee == "some sys_fee"
      assert transaction.txid == "some txid"
      assert transaction.type == "some type"
      assert transaction.version == "some version"
      assert transaction.vin == []
      assert transaction.vout == []
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert %Transaction{} = transaction
      assert transaction.attributes == []
      assert transaction.net_fee == "some updated net_fee"
      assert transaction.nonce == 43
      assert transaction.scripts == []
      assert transaction.size == 43
      assert transaction.sys_fee == "some updated sys_fee"
      assert transaction.txid == "some updated txid"
      assert transaction.type == "some updated type"
      assert transaction.version == "some updated version"
      assert transaction.vin == []
      assert transaction.vout == []
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
