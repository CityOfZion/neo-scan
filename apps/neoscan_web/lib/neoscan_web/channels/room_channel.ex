defmodule NeoscanWeb.RoomChannel do
  use Phoenix.Channel
  alias NeoscanMonitor.Api

  def join("room:home", _payload, socket) do
    {:ok, %{:blocks => Api.get_blocks, :transactions => Api.get_transactions}, socket}
  end

  def broadcast_change(state) do
    payload = %{
      "blocks" => state.blocks,
      "transactions" => state.transactions,
    }

    NeoscanWeb.Endpoint.broadcast("room:home", "change", payload)
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

end
