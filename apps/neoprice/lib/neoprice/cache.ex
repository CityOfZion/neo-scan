defmodule Neoprice.Cache do
  @moduledoc "macro to define a buffer"
  use GenServer
  alias Neoprice.Cryptocompare

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
    :ets.new(
      :"#{state.name}_day",
      [:public, :set, :named_table, {:read_concurrency, true}]
    )
    :ets.new(
      :"#{state.name}_3_m",
      [:public, :set, :named_table, {:read_concurrency, true}]
    )
    :ets.new(
      :"#{state.name}_1_m",
      [:public, :set, :named_table, {:read_concurrency, true}]
    )
    :ets.new(
      :"#{state.name}_1_w",
      [:public, :set, :named_table, {:read_concurrency, true}]
    )
    :ets.new(
      :"#{state.name}_1_d",
      [:public, :set, :named_table, {:read_concurrency, true}]
    )
    Process.send_after(self(), :seed, 0)
    {:ok, state}
  end

  def handle_info(:seed, state) do
    seed(state)
    {:noreply, state}
  end

  def seed(state) do
    seed_day(state.name)
    seed_3_m(state.name)
    seed_1_m(state.name)
    seed_1_w(state.name)
    seed_1_d(state.name)
  end

  defp seed_day(name) do
    elements = Cryptocompare.day_prices(
      name.start_day,
      now(),
      name.from_symbol(),
      name.to_symbol(),
      1
    )
    :ets.insert(:"#{name}_day", elements)
  end

  defp seed_3_m(name) do
    to = now()
    from = to - 24 * 3600 * 31 * 3
    elements = Cryptocompare.hour_prices(
      from,
      to,
      name.from_symbol(),
      name.to_symbol(),
      3
    )
    :ets.insert(:"#{name}_3_m", elements)
  end

  defp seed_1_m(name) do
    to = now()
    from = to - 24 * 3600 * 31
    elements = Cryptocompare.hour_prices(
      from,
      to,
      name.from_symbol(),
      name.to_symbol(),
      1
    )
    :ets.insert(:"#{name}_1_m", elements)
  end

  defp seed_1_w(name) do
    to = now()
    from = to - 24 * 3600 * 7
    elements = Cryptocompare.minute_prices(
      from,
      to,
      name.from_symbol(),
      name.to_symbol(),
      15
    )
    :ets.insert(:"#{name}_1_w", elements)
  end

  defp seed_1_d(name) do
    to = now()
    from = to - 24 * 3600
    elements = Cryptocompare.minute_prices(
      from,
      to,
      name.from_symbol(),
      name.to_symbol(),
      1
    )
    :ets.insert(:"#{name}_1_d", elements)
  end

  def sync() do

  end

  defp now(), do: DateTime.utc_now() |> DateTime.to_unix()


  def get_day(name), do: :ets.tab2list(:"#{name}_day")
  def get_3_m(name), do: :ets.tab2list(:"#{name}_3_m")
  def get_1_m(name), do: :ets.tab2list(:"#{name}_3_m")
  def get_1_w(name), do: :ets.tab2list(:"#{name}_1_w")
  def get_1_d(name), do: :ets.tab2list(:"#{name}_1_d")
end
