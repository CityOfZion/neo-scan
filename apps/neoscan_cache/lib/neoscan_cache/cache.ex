defmodule NeoscanCache.Cache do
  use GenServer

  require Logger

  # Callbacks

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    :ets.new(__MODULE__, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{}}
  end

  def set(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] ->
        result

      _ ->
        nil
    end
  rescue
    ArgumentError ->
      Logger.warn("ETS is not initialized")
      nil
  end

  def get_price_history(from, to, definition) do
    get({from, to, definition})
  end

  def set_price_history(from, to, definition, history) do
    set({from, to, definition}, history)
  end

  def get_price, do: get(:price)
  def get_blocks, do: get(:blocks)
  def get_transactions, do: get(:transactions)
  def get_stats, do: get(:stats)

  def set_price(price), do: set(:price, price)
  def set_blocks(blocks), do: set(:blocks, blocks)
  def set_transactions(transactions), do: set(:transactions, transactions)
  def set_stats(stats), do: set(:stats, stats)
end
