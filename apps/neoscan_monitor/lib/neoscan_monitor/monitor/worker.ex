defmodule NeoscanMonitor.Worker do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanMonitor.Api module(look there for more info)
  """

  use GenServer
  alias NeoscanMonitor.Utils
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.ChainAssets

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    monitor_nodes = Utils.load()
    blocks = Blocks.home_blocks
    transactions = Transactions.home_transactions
                    |> Utils.add_vouts
    assets = ChainAssets.list_assets
              |> Utils.get_stats
    contracts = Transactions.list_contracts
    stats = Utils.get_general_stats()
    addresses = Addresses.list_latest()
                 |> Utils.count_txs
    Process.send(
      NeoscanMonitor.Server,
      {
        :state_update,
        %{
          :monitor => monitor_nodes,
          :blocks => blocks,
          :transactions => transactions,
          :assets => assets,
          :contracts => contracts,
          :stats => stats,
          :addresses => addresses
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
        :contracts => contracts,
        :stats => stats,
        :addresses => addresses
      }
    }
  end

  def handle_info(:update_nodes, state) do
    schedule_nodes() # Reschedule once more
    new_state = Map.merge(state, %{
        :monitor => Utils.load(),
        :assets => state.assets
                    |> Utils.get_stats,
        :stats => Utils.get_general_stats(),
        :addresses => Addresses.list_latest()
                       |> Utils.count_txs
      })

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
                     :hash => block.hash,
                     :size => block.size
                   } | state.blocks
                 ]
                 |> Utils.cut_if_more(count)

    new_state = Map.put(state, :blocks, new_blocks)
    {:noreply, new_state}
  end

  def handle_cast({:add_transaction, transaction, vouts}, state) do
    count = Enum.count(state.transactions)
    clean_vouts = Enum.map(vouts, fn vout ->
                    {:ok, result} = Morphix.atomorphiform(vout)
                    Map.put(result, :address_hash, result.address)
                    |> Map.delete(:address)
                  end)
    new_transactions = [
                         %{
                           :id => transaction.id,
                           :type => transaction.type,
                           :time => transaction.time,
                           :txid => transaction.txid,
                           :block_height => transaction.block_height,
                           :vin => transaction.vin,
                           :claims => transaction.claims,
                           :sys_fee => transaction.sys_fee,
                           :net_fee => transaction.net_fee,
                           :size => transaction.size,
                           :vouts => clean_vouts,
                         } | state.transactions
                       ]
                       |> Utils.cut_if_more(count)

    new_state = Map.put(state, :transactions, new_transactions)
    {:noreply, new_state}
  end

  def handle_cast({:add_asset, asset}, state) do
    new_assets = [asset | state.assets]

    new_state = Map.put(state, :assets, new_assets)
    {:noreply, new_state}
  end

  def handle_cast({:add_contract, contract, vouts}, state) do
    clean_vouts = Enum.map(vouts, fn vout ->
                    {:ok, result} = Morphix.atomorphiform(vout)
                    Map.put(result, :address_hash, result.address)
                    |> Map.delete(:address)
                  end)
    new_contracts = [Map.put(contract, :vouts, clean_vouts) | state.contracts]

    new_state = Map.put(state, :contracts, new_contracts)
    {:noreply, new_state}
  end

  defp schedule_nodes do
    Process.send_after(self(), :update_nodes, 30_000) # In 10s
  end

  defp schedule_update do
    Process.send_after(self(), :update, 10_000) # In 10s
  end

end
