defmodule NeoscanMonitor.Worker do
  use GenServer
  alias NeoscanMonitor.Utils

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__ )
  end

  def init( :ok ) do
    schedule_work()
    state = Utils.load()
    Process.send(NeoscanMonitor.Server, {:state_update, state}, [])
    {:ok, state}
  end

  def handle_info(:update, _state) do
    schedule_work() # Reschedule once more
    new_state = Utils.load()
    Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
    {:noreply, new_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :update, 1*60*1000) # In 5 minutes
  end


end
