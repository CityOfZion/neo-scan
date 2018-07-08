defmodule NeoscanCache.Cache do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanCache.Api module(look there for more info)
  """

  use GenServer
  alias Neoscan.Blocks
  alias Neoscan.Assets
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.Counters
  alias Neoscan.BlockGasGeneration
  alias NeoscanCache.CryptoCompareWrapper

  alias NeoscanCache.EtsProcess

  require Logger

  @update_interval 1_000
  @update_interval_price 5_000

  require Logger

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # run initial queries and fill state with all info needed in the app,
  # then sends message with new state to server module
  def init(:ok) do
    EtsProcess.create_table(__MODULE__)
    Process.send_after(self(), :broadcast, 30_000)
    sync()
    sync_price()
    {:ok, :ok}
  end

  def set(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    try do
      :ets.lookup(__MODULE__, key)
    rescue
      ArgumentError ->
        Logger.warn("ETS is not initialized")
        nil
    else
      [{^key, result}] ->
        result

      _ ->
        nil
    end
  end

  defp get_blocks do
    blocks = Enum.take(get(:blocks), 5)

    Enum.map(
      blocks,
      &%{
        hash: Base.encode16(&1.hash, case: :lower),
        index: &1.index,
        size: &1.size,
        time: DateTime.to_unix(&1.time),
        tx_count: &1.tx_count
      }
    )
  end

  defp get_transactions do
    transactions = Enum.take(get(:transactions), 5)

    Enum.map(
      transactions,
      &%{
        txid: Base.encode16(&1.hash, case: :lower),
        type: &1.type,
        time: DateTime.to_unix(&1.block_time)
      }
    )
  end

  def handle_info(:broadcast, state) do
    blocks = get_blocks()
    transactions = get_transactions()

    payload = %{
      "blocks" => blocks,
      "transactions" => transactions,
      "transfers" => [],
      "price" => get(:price),
      "stats" => get(:stats)
    }

    if function_exported?(NeoscanWeb.Endpoint, :broadcast, 3) do
      apply(NeoscanWeb.Endpoint, :broadcast, ["room:home", "change", payload])
    end

    # In 10 seconds
    Process.send_after(self(), :broadcast, 1_000)
    {:noreply, state}
  end

  def handle_info(:sync_price, _) do
    sync_price()
    {:noreply, :ok}
  end

  def handle_info(:sync, _) do
    sync()
    {:noreply, :ok}
  end

  # handles misterious messages received by unknown caller
  def handle_info({_ref, {:ok, _port, _pid}}, state) do
    {:noreply, state}
  end

  def get_general_stats do
    %{
      :total_blocks => Counters.count_blocks(),
      :total_transactions => Counters.count_transactions(),
      :total_transfers => 0,
      :total_addresses => Counters.count_addresses()
    }
  end

  # update nodes and stats information
  def sync() do
    Process.send_after(self(), :sync, @update_interval)
    blocks = Blocks.paginate(1).entries
    transactions = Transactions.paginate(1).entries
    addresses = Addresses.paginate(1).entries
    assets = Assets.get_all()
    stats = get_general_stats()

    set(:blocks, blocks)
    set(:transactions, transactions)
    set(:assets, assets)
    set(:stats, stats)
    set(:addresses, addresses)
  end

  def sync_price() do
    Process.send_after(self(), :sync_price, @update_interval_price)

    case CryptoCompareWrapper.pricemultifull(["NEO", "GAS"], ["BTC", "USD"]) do
      {:ok, price} ->
        price = %{
          neo: %{
            btc: price[:RAW][:NEO][:BTC],
            usd: price[:RAW][:NEO][:USD]
          },
          gas: %{
            btc: add_gas_market_cap(price[:RAW][:GAS][:BTC]),
            usd: add_gas_market_cap(price[:RAW][:GAS][:USD])
          }
        }

        set(:price, price)

      _ ->
        Logger.warn("could not sync price")
    end
  end

  defp add_gas_market_cap(info) do
    current_index = Counters.count_blocks()
    current_index = if is_nil(current_index), do: 0, else: current_index - 1
    %{info | MKTCAP: info[:PRICE] * BlockGasGeneration.get_range_amount(0, current_index)}
  end
end
