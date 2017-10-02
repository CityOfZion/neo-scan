defmodule NeoscanMonitor.Worker do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanMonitor.Api module(look there for more info)
  """

  use GenServer
  alias NeoscanMonitor.Utils
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.ChainAssets

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    monitor_nodes = Utils.load()
    blocks = Blocks.home_blocks
    transactions = Transactions.home_transactions
    assets = ChainAssets.list_assets
    contracts = Transactions.list_contracts
    Process.send(
      NeoscanMonitor.Server,
      {
        :state_update,
        %{
          :monitor => monitor_nodes,
          :blocks => blocks,
          :transactions => transactions,
          :assets => assets,
          :contracts => contracts
        }
      },
      []
    )
    schedule_nodes()
    schedule_update()
    {
      :ok,
      %{
        :monitor => monitor_nodes,
        :blocks => blocks,
        :transactions => transactions,
        :assets => assets,
        :contracts => contracts
      }
    }
  end

  def handle_info(:update_nodes, state) do
    schedule_nodes() # Reschedule once more
    new_state = Map.put(state, :monitor, Utils.load())
    {:noreply, new_state}
  end

  def handle_info(:update, state) do
    schedule_update() # Reschedule once more
    Process.send(NeoscanMonitor.Server, {:state_update, state}, [])
    {:noreply, state}
  end

  def handle_info({_ref, {:ok, _port, _pid}}, state) do
    {:noreply, state}
  end

  def handle_cast({:add_block, block}, state) do
    count = Enum.count(state.blocks)
    new_blocks = [
                   %{
                     :index => block.index,
                     :time => block.time,
                     :tx_count => block.tx_count,
                     :hash => block.hash
                   } | state.blocks
                 ]
                 |> cut_if_more(count)

    new_state = Map.put(state, :blocks, new_blocks)
    {:noreply, new_state}
  end

  def handle_cast({:add_transaction, transaction}, state) do
    count = Enum.count(state.transactions)
    new_transactions = [
                         %{
                           :type => transaction.type,
                           :time => transaction.time,
                           :txid => transaction.txid
                         } | state.transactions
                       ]
                       |> cut_if_more(count)

    new_state = Map.put(state, :transactions, new_transactions)
    {:noreply, new_state}
  end

  def handle_cast({:add_asset, asset}, state) do
    new_assets = [asset | state.assets]

    new_state = Map.put(state, :assets, new_assets)
    {:noreply, new_state}
  end

  def handle_cast({:add_contract, contract}, state) do
    new_contracts = [contract | state.contracts]

    new_state = Map.put(state, :assets, new_contracts)
    {:noreply, new_state}
  end

  defp schedule_nodes() do
    Process.send_after(self(), :update_nodes, 30000) # In 10s
  end

  defp schedule_update() do
    Process.send_after(self(), :update, 10000) # In 10s
  end

  defp cut_if_more(list, count) when count == 15 do
    list
    |> Enum.drop(-1)
  end
  defp cut_if_more(list, _count) do
    list
  end

end
