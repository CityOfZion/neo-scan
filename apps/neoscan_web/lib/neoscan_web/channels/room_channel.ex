defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanCache.Api, as: CacheApi

  def join("room:home", _payload, socket) do
    {
      :ok,
      %{
        :blocks => get_blocks(),
        :transactions => get_transactions(),
        :price => CacheApi.get_price(),
        :stats => CacheApi.get_stats()
      },
      socket
    }
  end

  defp get_transactions do
    transactions = Enum.take(CacheApi.get_transactions(), 5)

    Enum.map(
      transactions,
      &%{
        txid: Base.encode16(&1.hash),
        type: &1.type,
        time: DateTime.to_unix(&1.block_time)
      }
    )
  end

  defp get_blocks do
    blocks = Enum.take(CacheApi.get_blocks().entries, 5)

    Enum.map(
      blocks,
      &%{
        hash: Base.encode16(&1.hash),
        index: &1.index,
        size: &1.size,
        time: DateTime.to_unix(&1.time),
        tx_count: &1.tx_count
      }
    )
  end

  def handle_out(event, payload, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
