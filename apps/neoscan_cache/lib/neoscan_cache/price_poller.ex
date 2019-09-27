defmodule NeoscanCache.PricePoller do
  @moduledoc """
  GenServer module responsable to poll crypto compare data
  """

  use GenServer
  alias Neoscan.BlockGasGeneration
  alias Neoscan.Counters
  alias NeoscanCache.Cache
  alias NeoscanCache.CryptoCompareWrapper

  require Logger

  @polling_interval 60_000
  @minimum_interval 1_000

  @period ["1d", "1w", "1m", "3m"]
  @to_symbols ["USD", "BTC"]
  @from_symbols ["NEO", "GAS"]

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
    do_poll()
    Process.send_after(self(), :poll, @polling_interval)
    {:noreply, state}
  end

  # handles mysterious messages received by unknown caller
  def handle_info(_, state) do
    {:noreply, state}
  end

  def do_poll do
    sync_price_details()
    Process.sleep(@minimum_interval)

    for from <- @from_symbols,
        to <- @to_symbols,
        period <- @period do
      Process.sleep(@minimum_interval)
      sync_price_history(from, to, period)
    end
  end

  def sync_price_details do
    case CryptoCompareWrapper.pricemultifull(@from_symbols, @to_symbols) do
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

        Cache.set_price(price)

      {:error, %{Cooldown: cool_down}} ->
        Logger.warn("Was asked to cool down for #{cool_down} s")
        Process.sleep(cool_down * 1_000)
        sync_price_details()
    end
  catch
    error, reason ->
      Logger.warn("could not sync price #{inspect({error, reason})}")
  end

  def sync_price_history(from, to, definition) do
    {function, aggregate, limit} = get_price_config(definition)

    case apply(
           CryptoCompareWrapper,
           function,
           [from, to, [extraParams: "neoscan", aggregate: aggregate, limit: limit]]
         ) do
      {:ok, %{Data: data}} ->
        history =
          Enum.reduce(data, %{}, fn %{time: time, open: value}, acc ->
            Map.put(acc, time, value)
          end)

        Cache.set_price_history(from, to, definition, history)

      {:error, %{Cooldown: cool_down}} ->
        Logger.warn("Was asked to cool down for #{cool_down} s")
        Process.sleep(cool_down * 1_000)
        sync_price_history(from, to, definition)
    end
  catch
    error, reason ->
      Logger.warn("could not sync price #{inspect({error, reason})}")
  end

  defp get_price_config("3m"), do: {:histo_day, 1, 90}
  defp get_price_config("1m"), do: {:histo_hour, 6, 120}
  defp get_price_config("1w"), do: {:histo_hour, 1, 168}
  defp get_price_config("1d"), do: {:histo_minute, 10, 144}

  defp add_gas_market_cap(info) do
    current_index = Counters.count_blocks()
    current_index = if is_nil(current_index), do: 0, else: current_index - 1
    %{info | MKTCAP: info[:PRICE] * BlockGasGeneration.get_range_amount(0, current_index)}
  end
end
