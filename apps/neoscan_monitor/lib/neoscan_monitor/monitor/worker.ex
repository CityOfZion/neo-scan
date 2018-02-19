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
  alias Neoscan.Transfers
  alias Neoscan.Addresses
  alias Neoscan.ChainAssets
  alias Neoprice.NeoBtc
  alias Neoprice.NeoUsd
  alias Neoprice.GasBtc
  alias Neoprice.GasUsd

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # run initial queries and fill state with all info needed in the app,
  # then sends message with new state to server module
  def init(:ok) do
    monitor_nodes = Utils.load()

    blocks = Blocks.home_blocks()

    transactions =
      Transactions.home_transactions()
      |> Utils.add_vouts()

    transfers = Transfers.home_transfers()

    assets =
      ChainAssets.list_assets()
      |> Utils.get_stats()

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
      :transfers => transfers,
      :assets => assets,
      :stats => stats,
      :addresses => addresses,
      :price => price,
      :tokens => [],
    }

    Process.send(NeoscanMonitor.Server, {:first_state_update, new_state}, [])
    # In 1s
    Process.send_after(self(), :update, 1_000)
    # In 1s
    Process.send_after(self(), :update_nodes, 1_000)
    {:ok, new_state}
  end

  # update nodes and stats information
  def handle_info(:update_nodes, state) do
    Utils.add_new_tokens()
    new_state =
      Map.merge(state, %{
        :monitor => Utils.load(),
        :assets =>
          ChainAssets.list_assets()
          |> Utils.get_stats(),
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
        :tokens => Utils.add_new_tokens(state.tokens)
      })

    # In 5s
    Process.send_after(self(), :update_nodes, 5_000)
    {:noreply, new_state}
  end

  # updates the state in the server module
  def handle_info(:update, state) do
    Process.send(Server, {:state_update, state}, [])
    # In 1s
    Process.send_after(self(), :update, 1_000)
    {:noreply, state}
  end

  # handles misterious messages received by unknown caller
  def handle_info({_ref, {:ok, _port, _pid}}, state) do
    {:noreply, state}
  end

  # adds a block to the state
  def add_block(block) do
    currrent = Server.get(:blocks)
    count = Enum.count(currrent)

    new_blocks =
      [
        %{
          :index => block.index,
          :time => block.time,
          :tx_count => block.tx_count,
          :hash => block.hash,
          :size => block.size
        }
        | currrent
      ]
      |> Utils.cut_if_more(count)

    Server.set(:blocks, new_blocks)
  end

  # adds a transfer to the state
  def add_transfer(transfer) do
    currrent = Server.get(:transfers)
    count = Enum.count(currrent)

    new_transfers =
      [
        %{
          :id => transfer.id,
          :address_from => transfer.address_from,
          :address_to => transfer.address_to,
          :amount => transfer.amount,
          :block_height => transfer.block_height,
          :txid => transfer.txid,
          :contract => transfer.contract,
          :time => transfer.time
        }
        | currrent
      ]
      |> Utils.cut_if_more(count)

    Server.set(:transfers, new_transfers)
  end

  # adds a transaction to the state
  def add_transaction(transaction, vouts) do
    current = Server.get(:transactions)
    count = Enum.count(current)

    clean_vouts =
      Enum.map(vouts, fn vout ->
        {:ok, result} = Morphix.atomorphiform(vout)

        Map.merge(result, %{
          :address_hash => result.address,
          :asset => String.slice(to_string(result.asset), -64..-1)
        })
        |> Map.delete(:address)
      end)

    new_transactions =
      [
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
          :asset => transaction.asset
        }
        | current
      ]
      |> Utils.cut_if_more(count)

    Server.set(:transactions, new_transactions)
  end
end
