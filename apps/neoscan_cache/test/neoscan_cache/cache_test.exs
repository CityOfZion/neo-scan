defmodule NeoscanCache.CacheTest do
  use NeoscanCache.DataCase

  import NeoscanCache.Factory
  alias NeoscanCache.Broadcast
  alias NeoscanCache.DbPoller
  alias NeoscanCache.PricePoller
  alias NeoscanCache.Cache

  test "handle_info(:broadcast, state)" do
    insert(:block)
    insert(:transaction, %{type: "contract_transaction"})
    DbPoller.do_poll()
    assert {:noreply, nil} == Broadcast.handle_info(:broadcast, nil)
  end

  test "price_history" do
    PricePoller.sync_price_history("NEO", "USD", "1d")
    PricePoller.sync_price_history("NEO", "USD", "1w")
    PricePoller.sync_price_history("NEO", "USD", "1m")
    PricePoller.sync_price_history("NEO", "USD", "3m")

    assert is_map(Cache.get_price_history("NEO", "USD", "1d"))
  end
end
