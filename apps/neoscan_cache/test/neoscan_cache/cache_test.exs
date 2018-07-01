defmodule NeoscanCache.CacheTest do
  use NeoscanCache.DataCase

  import NeoscanCache.Factory
  alias NeoscanCache.Cache

  test "handle_info(:broadcast, state)" do
    insert(:block)
    insert(:transaction, %{type: "contract_transaction"})
    Cache.sync()
    assert {:noreply, nil} == Cache.handle_info(:broadcast, nil)
  end
end
