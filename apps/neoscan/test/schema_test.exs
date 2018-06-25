defmodule Neoscan.SchemaTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  import Ecto.Query
  alias Neoscan.Repo
  alias Neoscan.Address
  alias Neoscan.AddressHistory
  alias Neoscan.AddressBalance

  test "create block" do
    _block = insert(:block)
  end

  test "create transaction" do
    _transaction = insert(:transaction)
  end

  test "create transfer" do
    _transfer = insert(:transfer)
  end

  test "create asset" do
    _asset = insert(:asset)
  end

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

  test "vout vin trigger (vin inserted after vout)" do
    vout = insert(:vout)

    address_history =
      Repo.one(from(a in AddressHistory, where: a.address_hash == ^vout.address_hash))

    assert vout.value == address_history.value

    address_balance =
      Repo.one(from(a in AddressBalance, where: a.address_hash == ^vout.address_hash))

    assert address_balance.value == vout.value

    insert(:vin, %{vout_n: vout.n, vout_transaction_hash: vout.transaction_hash})
    [ah1, ah2] = Repo.all(from(a in AddressHistory, where: a.address_hash == ^vout.address_hash))
    assert ah1.value == -ah2.value

    address_balance =
      Repo.one(from(a in AddressBalance, where: a.address_hash == ^vout.address_hash))

    assert 0 == address_balance.value
  end

  test "vout vin trigger (vin inserted before vout)" do
    vin = insert(:vin)

    vout = insert(:vout, %{n: vin.vout_n, transaction_hash: vin.vout_transaction_hash})

    [ah1, ah2] =
      Repo.all(
        from(
          a in AddressHistory,
          where: a.address_hash == ^vout.address_hash,
          order_by: :block_time
        )
      )

    assert ah1.value == -ah2.value
    assert ah1.block_time == vin.block_time
    assert ah2.block_time == vout.block_time

    address_balance =
      Repo.one(from(a in AddressBalance, where: a.address_hash == ^vout.address_hash))

    assert 0 == address_balance.value
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

    address_history2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        asset_hash: address_history.asset_hash
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
  end
end
