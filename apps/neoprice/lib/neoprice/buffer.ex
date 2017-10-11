defmodule Neoprice.Buffer do
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

      def from_symbol,
          do: unquote(
            if is_nil(opts[:from_symbol]), do: "BTC", else: opts[:from_symbol]
          )
      def to_symbol,
          do: unquote(
            if is_nil(opts[:to_symbol]), do: "BTC", else: opts[:to_symbol]
          )
      def get(), do: unquote(__MODULE__).get(__MODULE__)
    end
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, [name: state.name])
  end

  def init(state) do
    IO.inspect(state.name)
    :ets.new(
      state.name,
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
    #now = DateTime.utc_now()
     #     |> DateTime.to_unix()
#    elements = Cryptocompare.past_two_week(
#      now,
#      state.name.from_symbol(),
#      state.name.to_symbol()
#    )
    #:ets.insert(state.name, elements)
    state
  end

  def sync() do

  end

  def get(name) do
    :ets.tab2list(name)
  end
end
