defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanCache.Api, as: CacheApi

  def join("room:home", _payload, socket) do
    {
      :ok,
      %{
        :blocks => Enum.take(CacheApi.get_blocks(), 5),
        :transactions => Enum.take(CacheApi.get_transactions(), 5),
        :price => CacheApi.get_price(),
        :stats => CacheApi.get_stats()
      },
      socket
    }
  end

  def handle_out(event, payload, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
