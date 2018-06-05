defmodule Neoscan.Transactions.TransactionTest do
  use Neoscan.DataCase

  import Neoscan.Factory

  alias Neoscan.Transactions.Transaction

  test "changeset_with_block/1" do
    block = insert(:block)
    changeset = Transaction.changeset_with_block(block)

    refute changeset.valid?
    assert %{attributes: ["can't be blank"]} = errors_on(changeset)
    assert %{net_fee: ["can't be blank"]} = errors_on(changeset)
    assert %{scripts: ["can't be blank"]} = errors_on(changeset)
    assert %{size: ["can't be blank"]} = errors_on(changeset)
    assert %{sys_fee: ["can't be blank"]} = errors_on(changeset)
    assert %{txid: ["can't be blank"]} = errors_on(changeset)
    assert %{type: ["can't be blank"]} = errors_on(changeset)
    assert %{version: ["can't be blank"]} = errors_on(changeset)
    assert %{vin: ["can't be blank"]} = errors_on(changeset)
    assert %{time: ["can't be blank"]} = errors_on(changeset)
    assert %{block_height: ["can't be blank"]} = errors_on(changeset)
  end

  test "changeset_with_block/2" do
    block = insert(:block)

    attrs = %{
      attributes: [],
      net_fee: "12.32",
      scripts: [],
      size: 23,
      sys_fee: "23.3232",
      txid: "2332",
      type: "23232",
      version: 12,
      vin: [],
      time: 124,
      block_hash: "3434",
      block_height: 234
    }

    changeset = Transaction.changeset_with_block(block, attrs)

    assert changeset.valid?
  end
end
