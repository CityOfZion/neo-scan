defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase

  alias Neoscan.Transactions

  describe "transactions" do
    alias Neoscan.Transactions.Transaction

    @valid_attrs %{attributes: [], block: "some blockhash", net_fee: "some net_fee", nonce: 1, scripts: [], size: 1, sys_fee: "some sys_fee", txid: "some txid", type: "some type", version: 1, vin: [], vout: []}
    @update_attrs %{attributes: [], block: "some up blockhash", net_fee: "some up net_fee", nonce: 2, scripts: [], size: 2, sys_fee: "some up sys_fee", txid: "some up txid", type: "some up type", version: 2, vin: [], vout: []}
    @invalid_attrs %{attributes: nil, block: nil, net_fee: nil, nonce: nil, scripts: nil, size: nil, sys_fee: nil, txid: nil, type: nil, version: nil, vin: nil, vout: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction()

      transaction
    end

    # test "list_transactions/0 returns all transactions" do
    #   transaction = transaction_fixture()
    #   assert Transactions.list_transactions() == [transaction]
    # end
    #
    # test "get_transaction!/1 returns the transaction with given id" do
    #   transaction = transaction_fixture()
    #   assert Transactions.get_transaction!(transaction.id) == transaction
    # end
    #
    # test "create_transaction/1 with valid data creates a transaction" do
    #   assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
    #   assert transaction.attributes == []
    #   assert transaction.net_fee == "some net_fee"
    #   assert transaction.nonce == 1
    #   assert transaction.scripts == []
    #   assert transaction.size == 1
    #   assert transaction.sys_fee == "some sys_fee"
    #   assert transaction.txid == "some txid"
    #   assert transaction.type == "some type"
    #   assert transaction.version == 1
    #   assert transaction.vin == []
    #   assert transaction.vout == []
    # end
    #
    # test "create_transaction/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    # end
    #
    # test "update_transaction/2 with valid data updates the transaction" do
    #   transaction = transaction_fixture()
    #   assert {:ok, transaction} = Transactions.update_transaction(transaction, @update_attrs)
    #   assert %Transaction{} = transaction
    #   assert transaction.attributes == []
    #   assert transaction.net_fee == "some up net_fee"
    #   assert transaction.nonce == 2
    #   assert transaction.scripts == []
    #   assert transaction.size == 2
    #   assert transaction.sys_fee == "some up sys_fee"
    #   assert transaction.txid == "some up txid"
    #   assert transaction.type == "some up type"
    #   assert transaction.version == 2
    #   assert transaction.vin == []
    #   assert transaction.vout == []
    # end
    #
    # test "update_transaction/2 with invalid data returns error changeset" do
    #   transaction = transaction_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
    #   assert transaction == Transactions.get_transaction!(transaction.id)
    # end
    #
    # test "delete_transaction/1 deletes the transaction" do
    #   transaction = transaction_fixture()
    #   assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
    #   assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    # end
    #
    # test "change_transaction/1 returns a transaction changeset" do
    #   transaction = transaction_fixture()
    #   assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    # end
  end
end
