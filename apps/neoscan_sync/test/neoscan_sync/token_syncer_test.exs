defmodule NeoscanSync.TokenSyncerTest do
  use NeoscanSync.DataCase

  alias Neoscan.Repo
  alias Neoscan.Asset
  alias NeoscanSync.TokenSyncer

  test "handle_cast/2" do
    contract = Base.decode16!("3a4acd3647086e7c44398aac0349802e6a171129", case: :mixed)

    assert {:noreply, %{contracts: [contract]}} ==
             TokenSyncer.handle_cast(
               {:contract, 0, contract},
               %{contracts: [contract]}
             )

    assert 0 == Enum.count(Repo.all(from(Asset)))

    assert {:noreply, %{contracts: [contract]}} ==
             TokenSyncer.handle_cast(
               {:contract, 0, contract},
               %{contracts: []}
             )

    assert 1 == Enum.count(Repo.all(from(Asset)))
  end
end
