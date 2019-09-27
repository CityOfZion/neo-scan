defmodule NeoscanCache.DbPoller do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanCache.Api module(look there for more info)
  """

  use GenServer
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Counters
  alias NeoscanCache.Cache

  require Logger

  @polling_interval 1_000

  require Logger

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # run initial queries and fill state with all info needed in the app,
  # then sends message with new state to server module
  def init(:ok) do
    Process.send_after(self(), :poll, 0)
    {:ok, :ok}
  end

  def handle_info(:poll, state) do
    Process.send_after(self(), :poll, @polling_interval)
    :ok = do_poll()
    {:noreply, state}
  end

  # handles mysterious messages received by unknown caller
  def handle_info(_, state) do
    {:noreply, state}
  end

  # update nodes and stats information
  def do_poll() do
    blocks = Blocks.paginate(1).entries
    transactions = Transactions.paginate(1).entries

    stats = %{
      :total_blocks => Counters.count_blocks(),
      :total_transactions => Counters.count_transactions(),
      :total_transfers => 0,
      :total_addresses => Counters.count_addresses()
    }

    Cache.set_blocks(blocks)
    Cache.set_transactions(transactions)
    Cache.set_stats(stats)
    :ok
  end
end
