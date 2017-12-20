defmodule NeoscanMonitor.Server do
  @moduledoc """
  GenServer module responsable to retrive blocks, states, transactions
  and assets. Common interface to handle it is NeoscanMonitor.
  Api module(look there for more info)
  The state is updated using handle_info(:state_update, state)
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :ets.new(:server, [:set, :named_table, :public, read_concurrency: true,
                                             write_concurrency: true])
    {:ok, nil}
  end

  def set(key, value) do
    :ets.insert(:server, {key, value})
  end

  def get(key) do
    case :ets.lookup(:server, key) do
      [{^key, result}] -> result
       _ -> nil
    end
  end

  def handle_info({:first_state_update, new_state}, _state) do
    set(:monitor, new_state.monitor)
    set(:blocks, new_state.blocks)
    set(:transactions, new_state.transactions)
    set(:assets, new_state.assets)
    set(:stats, new_state.stats)
    set(:addresses, new_state.addresses)
    set(:price, new_state.price)
    Process.send_after(self(), :broadcast, 30_000) # In 30 seconds
    {:noreply, nil}
  end

  def handle_info({:state_update, new_state}, _state) do
    set(:monitor, new_state.monitor)
    set(:assets, new_state.assets)
    set(:stats, new_state.stats)
    set(:addresses, new_state.addresses)
    set(:price, new_state.price)
    {:noreply, nil}
  end

  def handle_info(:broadcast, state) do

    {blocks, _} = get(:blocks)
                  |> Enum.split(5)

    {transactions, _} = get(:transactions)
                        |> Enum.split(5)

    payload = %{
      "blocks" => blocks,
      "transactions" => transactions,
      "price" => get(:price),
      "stats" => get(:stats),
    }

    check_endpoint = function_exported?(NeoscanWeb.Endpoint, :broadcast, 3)

    if check_endpoint do
      broadcast = Application.fetch_env!(:neoscan_monitor, :broadcast)
      broadcast.(payload)
    end

    Process.send_after(self(), :broadcast, 1_000) # In 10 seconds
    {:noreply, state}
  end

end
