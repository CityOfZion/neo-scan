defmodule Neoprice.Cache do
  @moduledoc "macro to define a buffer"
  use GenServer
  alias Neoprice.Cryptocompare
  require Logger
  @minute 60
  @hour 3600
  @day 86400

  defmodule Config do
    defstruct [:cache_name, :definition, :aggregation, :duration]
  end

  defmacro __using__(opts \\ []) do
    quote do

      def worker do
        import Supervisor.Spec

        state = %{
          module: __MODULE__
        }
        worker(unquote(__MODULE__), [state], id: __MODULE__)
      end

      def from_symbol, do: unquote(
        if is_nil(opts[:from_symbol]), do: "BTC", else: opts[:from_symbol]
      )
      def to_symbol, do: unquote(
        if is_nil(opts[:to_symbol]), do: "BTC", else: opts[:to_symbol]
      )
      def config, do: unquote(
        if is_nil(opts[:config]), do: [], else: opts[:config]
      )
      def start_day, do: unquote(
        if is_nil(opts[:start_day]), do: 1_500_000_000, else: opts[:start_day]
      )
      def price(), do: unquote(__MODULE__).price(__MODULE__)
    end
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [module: state.module])
  end

  def init(state) do
    Enum.each(state.module.config, fn(cache) ->
         :ets.new(
           cache.cache_name,
           [:public, :ordered_set, :named_table, {:read_concurrency, true}]
         )
       end)
    Process.send_after(self(), :seed, 0)
    {:ok, state}
  end

  def handle_info(:seed, state) do
    Process.send_after(self(), :sync, 10_000)
    seed(state)
    {:noreply, state}
  end

  def handle_info(:sync, state) do
    Process.send_after(self(), :sync, 10_000)
    sync(state)
    {:noreply, state}
  end

  def price(module) do
    Cryptocompare.last_price(module.from_symbol(), module.to_symbol())
  end

  defp seed(state) do
    Enum.each(state.module.config, fn(cache) ->
      seed(state.module, cache)
    end)
  end

  defp seed(module, cache) do
    {from, to} = time_frame(module, cache)
    elements = Cryptocompare.get_price(cache.definition,
      from,
      to,
      module.from_symbol(),
      module.to_symbol(),
      cache.aggregation
    )
    :ets.insert(cache.cache_name, elements)
  end

  def sync(state) do
    Enum.each(state.module.config, fn(cache) ->
      sync_cache(cache, state.module)
    end)
  end

  defp sync_cache(config = %{cache_name: cache_name, definition: definition,
                    aggregation: aggregation}, module) do
    cache = :ets.tab2list(cache_name)
    {last_time , _} = List.last(cache)
    if next_value(definition, last_time, aggregation) < now() do
      Logger.debug fn ->
        "Syncing #{cache_name}"
      end
      elements = Cryptocompare.get_price(definition,
        last_time + 1,
        now(),
        module.from_symbol,
        module.to_symbol,
        aggregation
      )
      :ets.insert(cache_name, elements)
      delete_old_values(config, module, cache)
    end
  end

  defp time_frame(module, %{duration: :start}), do: {module.start_day, now()}
  defp time_frame(_, %{duration: duration}) do
    now = now()
    {now - duration, now}
  end

  defp delete_old_values(config, module, cache) do
    {from, _} = time_frame(module, config)
    Enum.reduce_while(cache, nil, fn({k, _}, _) ->
      if k < from do
        :ets.delete(config.cache_name, k)
        Logger.debug fn ->
          "Deleteting #{k}"
        end
        {:cont, nil}
      else
        {:halt, nil}
      end
    end)
  end

  defp next_value(:day, time, aggregation), do: time + @day * aggregation
  defp next_value(:hour, time, aggregation), do: time + @hour * aggregation
  defp next_value(:minute, time, aggregation), do: time + @minute * aggregation

  defp now(), do: DateTime.utc_now() |> DateTime.to_unix()
end
