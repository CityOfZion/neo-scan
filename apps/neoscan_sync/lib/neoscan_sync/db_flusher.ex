defmodule NeoscanSync.DbFlusher do
  alias Neoscan.Flush

  use GenServer

  @flush_interval 5_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Process.send_after(self(), :flush, 0)
    {:ok, nil}
  end

  @impl true
  def handle_info(:flush, state) do
    Process.send_after(self(), :flush, @flush_interval)
    flush()
    {:noreply, state}
  end

  def flush do
    Flush.all()
  end
end
