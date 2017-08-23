defmodule NeoscanMonitor.Worker do
  use GenServer
  alias NeoscanMonitor.Utils
  alias Neoscan.Blocks
  alias Neoscan.Transactions

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__ )
  end

  def init( :ok ) do
    schedule_work()
    monitor_nodes = Utils.load()
    blocks = Blocks.home_blocks
    transactions = Transactions.home_transactions
    assets = Transactions.list_assets
    contracts = Transactions.list_contracts
    Process.send(NeoscanMonitor.Server, {:state_update, %{:monitor => monitor_nodes, :blocks => blocks, :transactions => transactions, :assets => assets, :contracts => contracts}}, [])
    {:ok, %{:monitor => monitor_nodes, :blocks => blocks, :transactions => transactions, :assets => assets, :contracts => contracts}}
  end

  def handle_info(:update_nodes, state) do
    schedule_work() # Reschedule once more
    new_state = Map.put(state, :monitor, Utils.load())
    Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
    {:noreply, new_state}
  end

  def handle_info( { _ref, { :ok, _port, _pid } }, state) do
    {:noreply, state}
  end

  def handle_cast({:add_block, block}, state) do
      new_blocks = [%{:index => block.index, :time => block.time, :tx_count => block.tx_count, :hash => block.hash} | state.blocks]
        |> Enum.drop(-1)

      new_state = Map.put(state, :blocks, new_blocks)
      Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
      {:noreply, new_state}
  end

  def handle_cast({:add_transaction, transaction}, state) do
      count = Enum.count(state.transactions)
      new_transactions = [%{:type => transaction.type, :time => transaction.time, :txid => transaction.txid} | state.transactions]
        |> cut_if_more(count)

      new_state = Map.put(state, :transactions, new_transactions)
      Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
      {:noreply, new_state}
  end

  def handle_cast({:add_asset, asset}, state) do
      new_assets = [asset | state.assets]

      new_state = Map.put(state, :assets, new_assets)
      Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
      {:noreply, new_state}
  end

  def handle_cast({:add_contract, contract}, state) do
      new_contracts = [contract | state.contracts]

      new_state = Map.put(state, :assets, new_contracts)
      Process.send(NeoscanMonitor.Server, {:state_update, new_state}, [])
      {:noreply, new_state}
  end

  defp schedule_work() do
    Process.send_after(self(), :update_nodes, 1*60*1000) # In 1 minute
  end

  defp cut_if_more(transactions, count) when count == 15 do
    transactions
    |> Enum.drop(-1)
  end
  defp cut_if_more(transactions, _count) do
    transactions
  end


end
