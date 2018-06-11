defmodule Neoscan.VoutTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  import Ecto.Query
  alias Neoscan.Repo
  alias Neoscan.Address
  alias Neoscan.AddressBalance

  test "create vout" do
    _vout = insert(:vout)
  end

  test "create vin" do
    _vin = insert(:vin)
  end

  test "create claim" do
    _claim = insert(:claim)
  end

  test "create address" do
    _address = insert(:address)
  end

  test "create address_balance" do
    _address_balance = insert(:address_balance)
  end

  test "create address_history" do
    _address_history = insert(:address_history)
  end

  test "trigger address history" do
    address_history = insert(:address_history)
    address = Repo.one(from(a in Address, where: a.hash == ^address_history.address_hash))
    assert address.hash == address_history.address_hash
    assert address.first_transaction_time == address_history.block_time
    assert address.last_transaction_time == address_history.block_time
    assert 1 == address.tx_count

    address_balance =
      Repo.one(from(a in AddressBalance, where: a.address_hash == ^address_history.address_hash))

    assert address_balance.address_hash == address_history.address_hash
    assert address_balance.value == address_history.value
    assert address_balance.asset == address_history.asset

    address_history2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        asset: address_history.asset
      })

    address = Repo.one(from(a in Address, where: a.hash == ^address_history.address_hash))
    assert address.hash == address_history.address_hash
    assert address.first_transaction_time == address_history.block_time
    assert address.last_transaction_time == address_history2.block_time
    assert 2 == address.tx_count

    address_balance =
      Repo.one(from(a in AddressBalance, where: a.address_hash == ^address_history.address_hash))

    assert address_balance.address_hash == address_history.address_hash
    assert address_balance.value == address_history.value + address_history2.value
    assert address_balance.asset == address_history.asset
  end
end
