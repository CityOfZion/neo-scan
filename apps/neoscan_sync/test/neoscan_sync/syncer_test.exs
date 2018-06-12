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

  test "import_block/1" do
    assert {:ok, _} = Syncer.insert_block(Syncer.download_block(0))

    assert 1 == Enum.count(Repo.all(from(Block)))
    assert 4 == Enum.count(Repo.all(from(Transaction)))
    assert 1 == Enum.count(Repo.all(from(Address)))
    assert 1 == Enum.count(Repo.all(from(AddressBalance)))
    assert 1 == Enum.count(Repo.all(from(AddressHistory)))
    assert 2 == Enum.count(Repo.all(from(Asset)))

    assert {:ok, _} = Syncer.insert_block(Syncer.download_block(1_444_843))

    assert 2 == Enum.count(Repo.all(from(Block)))
    assert 42 == Enum.count(Repo.all(from(Transaction)))
    assert 45 == Enum.count(Repo.all(from(Address)))
    assert 45 == Enum.count(Repo.all(from(AddressBalance)))
    assert 45 == Enum.count(Repo.all(from(AddressHistory)))
    assert 3 == Enum.count(Repo.all(from(Transfer)))
  end
end
