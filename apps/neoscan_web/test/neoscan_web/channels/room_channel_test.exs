defmodule NeoscanWeb.RoomChannelTest do
  use NeoscanWeb.ChannelCase
  alias NeoscanWeb.RoomChannel
  import NeoscanWeb.Factory

  alias NeoscanCache.Cache

  test "join room" do
    insert(:block)
    insert(:transaction)
    Cache.sync()

    {:ok, payload, _socket} = subscribe_and_join(socket("user_id", %{}), RoomChannel, "room:home")
    assert 1 == Enum.count(payload.transactions)
    assert 1 == Enum.count(payload.blocks)
  end
end
