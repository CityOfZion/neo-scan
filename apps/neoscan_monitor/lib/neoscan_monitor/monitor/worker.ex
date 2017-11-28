defmodule NeoscanMonitor.Worker do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanMonitor.Api module(look there for more info)
  """

  use GenServer
  alias NeoscanMonitor.Utils
  alias NeoscanMonitor.Server
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.ChainAssets
  alias Neoprice.NeoBtc
  alias Neoprice.NeoUsd
  alias Neoprice.GasBtc
  alias Neoprice.GasUsd

  #starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #run initial queries and fill state with all info needed in the app,
  #then sends message with new state to server module
  def init(:ok) do

    monitor_nodes = Utils.load()

    blocks = Blocks.home_blocks

    transactions = Transactions.home_transactions
                   |> Utils.add_vouts

    assets = ChainAssets.list_assets
             |> Utils.get_stats

    stats = Utils.get_general_stats()

    addresses = Addresses.list_latest()

    price = %{
      neo: %{
        btc: NeoBtc.last_price_full(),
        usd: NeoUsd.last_price_full()
      },
      gas: %{
        btc: GasBtc.last_price_full(),
        usd: GasUsd.last_price_full()
      }
    }

    new_state = %{
      :monitor => monitor_nodes,
      :blocks => blocks,
      :transactions => transactions,
      :assets => assets,
      :stats => stats,
      :addresses => addresses,
      :price => price,
    }

    Process.send(
      NeoscanMonitor.Server,
      {:first_state_update, new_state},
      []
    )
    Process.send_after(self(), :update, 1_000) # In 1s
    Process.send_after(self(), :update_nodes, 1_000) # In 1s
    {:ok, new_state}
  end

  #update nodes and stats information
  def handle_info(:update_nodes, state) do
    new_state = Map.merge(
      state,
      %{
        :monitor => Utils.load(),
        :assets => ChainAssets.list_assets
                   |> Utils.get_stats,
        :stats => Utils.get_general_stats(),
        :addresses => Addresses.list_latest(),
        :price => %{
          neo: %{
            btc: NeoBtc.last_price_full(),
            usd: NeoUsd.last_price_full()
          },
          gas: %{
            btc: GasBtc.last_price_full(),
            usd: GasUsd.last_price_full()
          }
        },
      }
    )

    Process.send_after(self(), :update_nodes, 5_000) # In 5s
    {:noreply, new_state}
  end

  #updates the state in the server module
  def handle_info(:update, state) do
    Process.send(Server, {:state_update, state}, [])
    Process.send_after(self(), :update, 1_000) # In 1s
    {:noreply, state}
  end

  #handles misterious messages received by unknown caller
  def handle_info({_ref, {:ok, _port, _pid}}, state) do
    {:noreply, state}
  end

  #adds a block to the state
  def add_block(block) do
    currrent = Server.get(:blocks)
    count = Enum.count(currrent)
    new_blocks = [
                   %{
                     :index => block.index,
                     :time => block.time,
                     :tx_count => block.tx_count,
                     :hash => block.hash,
                     :size => block.size
                   } | currrent
                 ]
                 |> Utils.cut_if_more(count)

    Server.set(:blocks, new_blocks)
  end

  #adds a transaction to the state
  def add_transaction(transaction, vouts) do
    current = Server.get(:transactions)
    count = Enum.count(current)
    clean_vouts = Enum.map(
      vouts,
      fn vout ->
        {:ok, result} = Morphix.atomorphiform(vout)
        Map.merge(
          result,
          %{
            :address_hash => result.address,
            :asset => String.slice(to_string(result.asset), -64..-1),
          }
        )
        |> Map.delete(:address)
      end
    )
    new_transactions = [
                         %{
                           :id => transaction.id,
                           :type => transaction.type,
                           :time => transaction.time,
                           :txid => transaction.txid,
                           :block_height => transaction.block_height,
                           :block_hash => transaction.block_hash,
                           :vin => transaction.vin,
                           :claims => transaction.claims,
                           :sys_fee => transaction.sys_fee,
                           :net_fee => transaction.net_fee,
                           :size => transaction.size,
                           :vouts => clean_vouts,
                           :asset => transaction.asset,
                         } | current
                       ]
                       |> Utils.cut_if_more(count)

    Server.set(:transactions, new_transactions)
  end

  def set_filtered_count(type) do
    count = Transactions.count_transactions([type])
    Server.set(:filtered_trans_count, [type, count])
    IO.puts "first count #{count}"
    Process.send_after(self(), :update_filtered_count, 10_000) # In 10s
    count
  end

  def handle_info(:update_filtered_count, state) do
    case Server.get(:filtered_trans_count) do
      nil -> nil
      [type, _count] ->
        count = Transactions.count_transactions([type])
        IO.puts "follow on counts #{count}"
        Server.set(:filtered_trans_count, [type, count])
        Process.send_after(self(), :update_filtered_count, 10_000) # In 10s
    end
    {:noreply, state}
  end

end
