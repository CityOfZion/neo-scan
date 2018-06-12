defmodule NeoscanCache.CacheTest do
  use NeoscanCache.DataCase

  alias NeoscanCache.Cache

  test "handle_info(:broadcast, state)" do
    assert {:noreply, nil} == Cache.handle_info(:broadcast, nil)
  end
end
