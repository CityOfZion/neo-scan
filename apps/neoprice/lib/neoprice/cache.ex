defmodule Neoprice.Cache do
  @moduledoc "macro to define a buffer"
  use GenServer
  alias Neoprice.Cryptocompare
  require Logger
  @minute 60
  @hour 3600
  @day 86400
  @month 2678400

  defmodule Config do
    defstruct [:cache_name, :definition, :aggregation, :duration]
  end

  defmacro __using__(opts \\ []) do
    quote do

      def worker do
        import Supervisor.Spec

        state = %{
          name: __MODULE__
        }
        worker(unquote(__MODULE__), [state], id: __MODULE__)
      end

      def from_symbol, do: unquote(
        if is_nil(opts[:from_symbol]), do: "BTC", else: opts[:from_symbol]
      )
      def to_symbol, do: unquote(
        if is_nil(opts[:to_symbol]), do: "BTC", else: opts[:to_symbol]
      )
      def start_day, do: unquote(
        if is_nil(opts[:start_day]), do: 1_500_000_000, else: opts[:start_day]
      )
      def get_day(), do: unquote(__MODULE__).get_day(__MODULE__)
      def get_3_m(), do: unquote(__MODULE__).get_3_m(__MODULE__)
      def get_1_m(), do: unquote(__MODULE__).get_1_m(__MODULE__)
      def get_1_w(), do: unquote(__MODULE__).get_1_d(__MODULE__)
      def get_1_d(), do: unquote(__MODULE__).get_1_d(__MODULE__)
    end
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: state.name])
  end

  def init(state) do
    caches = [
      %Config{cache_name: :"#{state.name}_day", definition: :day,
        duration: :start, aggregation: 1},
      %Config{cache_name: :"#{state.name}_3_m", definition: :hour,
        duration: @month * 3, aggregation: 3},
      %Config{cache_name: :"#{state.name}_1_m", definition: :hour,
        duration: @month, aggregation: 1},
      %Config{cache_name: :"#{state.name}_1_w", definition: :minute,
        duration: 7 * @day, aggregation: 15},
      %Config{cache_name: :"#{state.name}_1_d", definition: :minute,
        duration: @day, aggregation: 1}
    ]
    Enum.each(caches, fn(cache) ->
         :ets.new(
           cache.cache_name,
           [:public, :ordered_set, :named_table, {:read_concurrency, true}]
         )
       end)
    Process.send_after(self(), :seed, 0)
    {:ok, Map.put(state, :caches, caches)}
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


  def seed(state) do
    Enum.each(state.caches, fn(cache) ->
      seed(state.name, cache)
    end)
  end

  defp seed(name, cache) do
    {from, to} = time_frame(name, cache)
    elements = Cryptocompare.get_price(cache.definition,
      from,
      to,
      name.from_symbol(),
      name.to_symbol(),
      cache.aggregation
    )
    :ets.insert(cache.cache_name, elements)
  end

  def sync(state) do
    Enum.each(state.caches, fn(cache) ->
      sync_cache(cache, state.name)
    end)
  end

  defp sync_cache(config = %{cache_name: cache_name, definition: definition,
                    aggregation: aggregation}, name) do
    cache = :ets.tab2list(cache_name)
    {last_time , _} = List.last(cache)
    if next_value(definition, last_time, aggregation) < now() do
      Logger.debug fn ->
        "Syncing #{cache_name}"
      end
      elements = Cryptocompare.get_price(definition,
        last_time + 1,
        now(),
        name.from_symbol,
        name.to_symbol,
        aggregation
      )
      :ets.insert(cache_name, elements)
      delete_old_values(config, name, cache)
    end
  end

  def time_frame(name, %{duration: :start}), do: {name.start_day, now()}
  def time_frame(_, %{duration: duration}) do
    now = now()
    {now - duration, now}
  end

  defp delete_old_values(config, name, cache) do
    {from, _} = time_frame(name, config)
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

  def get_day(name), do: :ets.tab2list(:"#{name}_day")
  def get_3_m(name), do: :ets.tab2list(:"#{name}_3_m")
  def get_1_m(name), do: :ets.tab2list(:"#{name}_3_m")
  def get_1_w(name), do: :ets.tab2list(:"#{name}_1_w")
  def get_1_d(name), do: :ets.tab2list(:"#{name}_1_d")
end
