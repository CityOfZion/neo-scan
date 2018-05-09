defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanMonitor.Api, as: MonitorApi

  def join("room:home", _payload, socket) do
    {blocks, _} =
      MonitorApi.get_blocks()
      |> Enum.split(5)

    {transactions, _} =
      MonitorApi.get_transactions()
      |> Enum.split(5)

    {
      :ok,
      %{
        :blocks => blocks,
        :transactions => transactions,
        :price => MonitorApi.get_price(),
        :stats => MonitorApi.get_stats()
      },
      socket
    }
  end

  def handle_out(event, payload, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end
end
