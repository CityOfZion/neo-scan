defmodule Neoscan.TransactionsTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Transactions

  describe "transaction" do
    alias Neoscan.Transactions.Transaction

    def transaction_fixture(_attrs \\ %{}) do
      insert(:transaction)
    end

    test "count_transactions_for_asset/1" do
      assert 0 == Transactions.count_transactions_for_asset("randomstuff")
      insert(:transaction, %{asset_moved: "12345678"})
      assert 1 == Transactions.count_transactions_for_asset("12345678")
    end

    test "home_transactions/0" do
      insert(:transaction, %{type: "MinerTransaction"})
      transaction = insert(:transaction)
      assert [transaction1] = Transactions.home_transactions()
      assert transaction.txid == transaction1.txid
    end

    test "get_last_transactions_for_asset/1" do
      transaction = insert(:transaction, %{asset_moved: "12345678"})
      vout = insert(:vout, %{transaction_id: transaction.id})

      assert [%{vouts: [vout2]} = transaction2] =
               Transactions.get_last_transactions_for_asset("12345678")

      assert transaction2.id == transaction.id
      assert vout.address_hash == vout2.address_hash
    end

    test "paginate_transactions/2" do
      transaction1 = insert(:transaction, %{type: "InvocationTransaction"})
      _transaction2 = insert(:transaction, %{type: "IssueTransaction"})
      _transaction3 = insert(:transaction, %{type: "RegisterTransaction"})
      _vout = insert(:vout, %{transaction_id: transaction1.id})
      assert 3 == Enum.count(Transactions.paginate_transactions(1))

      assert 2 ==
               Enum.count(
                 Transactions.paginate_transactions(1, ["IssueTransaction", "RegisterTransaction"])
               )

      # TODO this looks like a hack, it probably needs to be refactored.
      assert 1 == Enum.count(Transactions.paginate_transactions(1, ["issue"]))
      assert 0 == Enum.count(Transactions.paginate_transactions(1, ["IssueTransaction"]))
    end

    test "paginate_transactions_for_block/2" do
      block = insert(:block)

      transaction1 =
        insert(:transaction, %{type: "InvocationTransaction", block_hash: block.hash})

      insert(:vout, %{transaction_id: transaction1.id})

      assert 1 ==
               Enum.count(
                 Transactions.paginate_transactions_for_block(transaction1.block_hash, 1)
               )
    end

    test "get_transaction_vouts/1" do
      transaction1 = insert(:transaction, %{type: "InvocationTransaction"})
      insert(:vout, %{transaction_id: transaction1.id})
      assert [_] = Transactions.get_transaction_vouts(transaction1.id)
    end

    test "list_contracts/0" do
      insert(:transaction, %{type: "PublishTransaction"})
      insert(:transaction, %{type: "InvocationTransaction"})
      insert(:transaction, %{type: "IssueTransaction"})

      assert [_, _] = Transactions.list_contracts()
    end

    test "get_transaction_by_hash_for_view/1" do
      transaction = insert(:transaction, %{type: "PublishTransaction"})
      insert(:vout, %{transaction_id: transaction.id})

      assert %Transaction{vouts: [_]} =
               Transactions.get_transaction_by_hash_for_view(transaction.txid)
    end

    test "list_transactions/0 returns all transaction" do
      transaction = insert(:transaction)
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:transaction)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    #    test "create_transaction/2" do
    #      block = insert(:block)
    #      attrs = %{
    #        "attributes" => [],
    #        "net_fee" => "124",
    #        "scripts" => [],
    #        "size" => 23,
    #        "sys_fee" => "23.23",
    #        "version" => 12,
    #        "vout" => [],
    #        "vin" => [],
    #        "txid" => "24jn2jk1nj424jn2jk1nj424jn2jk1nj424jn2jk1nj424jn2jk1nj424jn2jk1n",
    #        "type" => "IssueTransaction"
    #      }
    #      Transactions.create_transaction(block, attrs)
    #    end

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
