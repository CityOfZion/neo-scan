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
  alias Neoscan.Claims.Unclaimed

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # run initial queries and fill state with all info needed in the app,
  # then sends message with new state to server module
  def init(:ok) do
    Process.send(self(), :repair, [])
    {:ok, update_cache(%{tokens: []})}
  end

  # update nodes and stats information
  defp update_cache(state) do
    Process.send_after(self(), :update_nodes, 5_000)
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

    tokens = Utils.add_new_tokens(state.tokens)

    %{
      :blocks => blocks,
      :transactions => transactions,
      :transfers => transfers,
      :assets => assets,
      :stats => stats,
      :addresses => addresses,
      :price => price,
      :tokens => tokens
    }
  end

  def handle_info(:update_nodes, state) do
    new_state = update_cache(state)
    Process.send(Server, {:state_update, state}, [])
    {:noreply, new_state}
  end

  # repair blocks on startup
  def handle_info(:repair, state) do
    Unclaimed.repair_blocks()
    {:noreply, state}
  end

  # handles misterious messages received by unknown caller
  def handle_info({_ref, {:ok, _port, _pid}}, state) do
    {:noreply, state}
  end
end
