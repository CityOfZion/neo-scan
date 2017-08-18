defmodule NeoscanMonitor.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__ )
  end

  def init( :ok ) do
    {:ok, []}
  end

  def handle_info({:state_update, new_state}, _state) do
    {:noreply, new_state}
  end

  def handle_call(:nodes, _from, state) do
    {:reply, state.nodes, state}
  end

  def handle_call(:height, _from, state) do
    {:reply, state.height, state}
  end

  def handle_call(:data, _from, state) do
    {:reply, state.data, state}
  end
end
