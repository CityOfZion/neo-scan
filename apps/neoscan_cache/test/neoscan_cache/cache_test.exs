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

  test "init/1" do
    Cache.init(:ok)
  end

  test "handle_info(:sync_price, _)" do
    Cache.handle_info(:sync_price, nil)
    Cache.handle_info(:sync, nil)
  end
end
