defmodule NeoscanMonitor.Server do
  use GenServer
  alias NeoscanMonitor.Utils

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__ )
  end

  def init( :ok ) do
    schedule_work() # Schedule work to be performed on start
    state = load()
    {:ok, state}
  end

  def handle_info(:work, _state) do
    schedule_work() # Reschedule once more
    new_state = load()
    {:noreply, new_state}
  end

  def handle_call(:nodes, _from, state) do
    {:reply, state.nodes, state}
  end

  def handle_call(:height, _from, state) do
    {:reply, state.height, state}
  end

  def handle_cast(:error, _state) do
    new_state = load()
    {:noreply, new_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5*60*1000) # In 5 minutes
  end

  defp load() do
    Utils.load()
  end
end
