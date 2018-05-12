defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanCache.Api, as: CacheApi

  def join("room:home", _payload, socket) do
    {blocks, _} =
      CacheApi.get_blocks()
      |> Enum.split(5)

    {transactions, _} =
      CacheApi.get_transactions()
      |> Enum.split(5)

    {
      :ok,
      %{
        :blocks => blocks,
        :transactions => transactions,
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
