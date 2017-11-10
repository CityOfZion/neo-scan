defmodule NeoscanWeb.RoomChannel do
  @moduledoc false
  use Phoenix.Channel
  alias NeoscanMonitor.Api
  alias NeoscanWeb.Endpoint

  def join("room:home", _payload, socket) do
    {blocks, _} = Api.get_blocks
                  |> Enum.split(5)

    {transactions, _} = Api.get_transactions
                        |> Enum.split(5)

    {
      :ok,
      %{
        :blocks => blocks,
        :transactions => transactions,
        :price => Api.get_price,
        :stats => Api.get_stats
      },
      socket
    }
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
