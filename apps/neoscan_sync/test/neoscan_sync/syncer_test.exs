defmodule NeoscanSync.SyncerTest do
  use NeoscanSync.DataCase

  alias NeoscanSync.Syncer
  alias Neoscan.Repo
  import Ecto.Query
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Address
  alias Neoscan.AddressBalance
  alias Neoscan.AddressHistory
  alias Neoscan.Asset
  alias Neoscan.Transfer

  import ExUnit.CaptureLog

  test "import_block/1" do
    assert :ok == Syncer.insert_block(Syncer.download_block(0))
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_addresses_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_transaction_balances_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_balances_queue()", [])

    assert 1 == Enum.count(Repo.all(from(Block)))
    assert 4 == Enum.count(Repo.all(from(Transaction)))
    assert 1 == Enum.count(Repo.all(from(Address)))
    assert 1 == Enum.count(Repo.all(from(AddressBalance)))
    assert 1 == Enum.count(Repo.all(from(AddressHistory)))
    assert 2 == Enum.count(Repo.all(from(Asset)))

    assert :ok == Syncer.insert_block(Syncer.download_block(1_444_843))

    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_addresses_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_transaction_balances_queue()", [])
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_balances_queue()", [])

    assert 2 == Enum.count(Repo.all(from(Block)))
    assert 42 == Enum.count(Repo.all(from(Transaction)))
    assert 48 == Enum.count(Repo.all(from(Address)))
    assert 48 == Enum.count(Repo.all(from(AddressBalance)))
    assert 48 == Enum.count(Repo.all(from(AddressHistory)))
    assert 3 == Enum.count(Repo.all(from(Transfer)))

    Process.sleep(5_000)
    assert 3 == Enum.count(Repo.all(from(Asset)))
  end

  test "sync_indexes/1" do
    assert :ok == Syncer.sync_indexes([0])
  end

  test "init(:ok)" do
    assert capture_log(fn ->
             Syncer.init(:ok)
           end) =~ "found 0 missing blocks"
  end
end
