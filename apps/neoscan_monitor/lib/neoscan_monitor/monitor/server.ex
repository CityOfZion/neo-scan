defmodule NeoscanMonitor.Server do
  @moduledoc """
  GenServer module responsable to retrive blocks, states, transactions
  and assets. Common interface to handle it is NeoscanMonitor.
  Api module(look there for more info)
  The state is updated using handle_info(:state_update,state)
  """

  use GenServer
  alias NeoscanWeb.RoomChannel
  alias Neoscan.ChainAssets

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_info({:state_update, new_state}, _state) do
    schedule_work()
    {:noreply, new_state}
  end

  def handle_info(:broadcast, state) do
    schedule_work() # Reschedule once more
    RoomChannel.broadcast_change(state)
    {:noreply, state}
  end

  def handle_call(:nodes, _from, state) do
    {:reply, state.monitor.nodes, state}
  end

  def handle_call(:height, _from, state) do
    {:reply, state.monitor.height, state}
  end

  def handle_call(:transactions, _from, state) do
    {:reply, state.transactions, state}
  end

  def handle_call(:blocks, _from, state) do
    {:reply, state.blocks, state}
  end

  def handle_call(:assets, _from, state) do
    {:reply, state.assets, state}
  end

  def handle_call({:asset_name, hash}, _from, state) do
    name = Enum.find(state.assets, fn %{:txid => txid} -> txid == hash end)
            |> Map.get(:name)
            |> ChainAssets.filter_name
    {:reply, name, state}
  end

  def handle_call(:addresses, _from, state) do
    {:reply, state.addresses, state}
  end

  def handle_call(:contracts, _from, state) do
    {:reply, state.contracts, state}
  end

  def handle_call(:data, _from, state) do
    {:reply, state.monitor.data, state}
  end

  defp schedule_work do
    Process.send_after(self(), :broadcast, 10_000) # In 10 seconds
  end
end
