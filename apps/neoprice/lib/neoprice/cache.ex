defmodule Neoprice.Cache do
  @moduledoc "macro to define a buffer"

  @cache_sync_interval Application.get_env(:neoprice, :cache_sync_interval)

  use GenServer
  alias Neoprice.Cryptocompare
  require Logger

  @minute 60
  @hour 3600
  @day 86_400

  @start_day 1_500_000_000
  @default_symbol "BTC"

  defmodule Config do
    @moduledoc false
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

      def price, do: unquote(__MODULE__).price(__MODULE__)
      def last_price_full, do: unquote(__MODULE__).last_price_full(__MODULE__)
      def from_symbol, do: unquote(__MODULE__).from_symbol(unquote(opts[:from_symbol]))
      def to_symbol, do: unquote(__MODULE__).to_symbol(unquote(opts[:to_symbol]))
      def config, do: unquote(__MODULE__).config(unquote(opts[:config]))
      def start_day, do: unquote(__MODULE__).start_day(unquote(opts[:start_day]))
    end
  end

  def from_symbol(nil), do: @default_symbol
  def from_symbol(symbol), do: symbol

  def to_symbol(nil), do: @default_symbol
  def to_symbol(symbol), do: symbol

  def config(nil), do: []
  def config(config), do: config

  def start_day(nil), do: @start_day
  def start_day(start_day), do: start_day

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, module: state.module)
  end

  def init(state) do
    Enum.each(state.module.config, fn cache ->
      :ets.new(cache.cache_name, [:public, :ordered_set, :named_table, {:read_concurrency, true}])
    end)

    Process.send_after(self(), :sync, 0)
    {:ok, state}
  end

  def handle_info(:sync, state) do
    Process.send_after(self(), :sync, @cache_sync_interval)
    sync(state)
    {:noreply, state}
  end

  def price(module) do
    Cryptocompare.last_price(module.from_symbol(), module.to_symbol())
  end

  def last_price_full(module) do
    Cryptocompare.last_price_full(module.from_symbol(), module.to_symbol())
  end

  def sync(state) do
    Enum.each(state.module.config, fn cache ->
      sync_cache(cache, state.module)
    end)
  end

  defp sync_cache(
         %{
           cache_name: cache_name,
           definition: definition,
           aggregation: aggregation
         } = config,
         module
       ) do
    cache = :ets.tab2list(cache_name)
    {last_time, _} = List.last(cache) || time_frame(module, config)

    if next_value(definition, last_time, aggregation) < now() do
      Logger.debug(fn -> "Syncing #{cache_name}" end)

      elements =
        Cryptocompare.get_price(
          definition,
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

    Enum.reduce_while(cache, nil, fn {k, _}, _ ->
      if k < from do
        :ets.delete(config.cache_name, k)
        Logger.debug(fn -> "Deleteting #{k}" end)
        {:cont, nil}
      else
        {:halt, nil}
      end
    end)
  end

  defp next_value(:day, time, aggregation), do: time + @day * aggregation
  defp next_value(:hour, time, aggregation), do: time + @hour * aggregation
  defp next_value(:minute, time, aggregation), do: time + @minute * aggregation

  defp now,
    do:
      DateTime.utc_now()
      |> DateTime.to_unix()
end
