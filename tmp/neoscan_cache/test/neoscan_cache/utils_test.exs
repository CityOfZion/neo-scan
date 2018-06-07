defmodule NeoscanCache.UtilsTest do
  use NeoscanCache.DataCase
  import NeoscanCache.Factory

  alias NeoscanCache.Utils
  alias Neoscan.Stats

  test "get_stats/1" do
    Stats.add_transaction_to_table(%{type: "InvocationTransaction", asset_moved: "121313"})
    insert(:address, %{balance: %{"121313" => 123}})
    insert(:address, %{balance: %{"121313" => 124}})
    insert(:address, %{balance: %{"121314" => 124}})

    assets = [%{contract: nil, txid: "121313"}, %{contract: "121314", txid: nil}]

    assert [
             %{contract: nil, stats: %{addresses: 2, transactions: 1}, txid: "121313"},
             %{contract: "121314", stats: %{addresses: 1, transactions: 0}, txid: nil}
           ] == Utils.get_stats(assets)
  end

  test "add_new_tokens/1" do
    assert [] == Utils.add_new_tokens(Utils.add_new_tokens())
  end
end
