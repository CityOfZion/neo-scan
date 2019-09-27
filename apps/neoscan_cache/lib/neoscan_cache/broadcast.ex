defmodule NeoscanCache.Broadcast do
  @moduledoc """
  GenServer module responsable to push data to websocket channel
  """

  use GenServer
  alias NeoscanCache.Cache

  require Logger

  @broadcast_interval 1_000
  @default_stats %{
    :total_blocks => 0,
    :total_transactions => 0,
    :total_transfers => 0,
    :total_addresses => 0
  }

  @default_price %{
    neo: %{
      btc: 0.0,
      usd: 0.0
    },
    gas: %{
      btc: 0.0,
      usd: 0.0
    }
  }

  require Logger

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # run initial queries and fill state with all info needed in the app,
  # then sends message with new state to server module
  def init(:ok) do
    Process.send_after(self(), :broadcast, 0)
    {:ok, :ok}
  end

  def handle_info(:broadcast, state) do
    Process.send_after(self(), :broadcast, @broadcast_interval)
    blocks = get_blocks()
    transactions = get_transactions()
    price = Cache.get_price() || @default_price
    stats = Cache.get_stats() || @default_stats

    payload = %{
      "blocks" => blocks,
      "transactions" => transactions,
      "transfers" => [],
      "price" => price,
      "stats" => stats
    }

    if function_exported?(NeoscanWeb.Endpoint, :broadcast, 3) do
      apply(NeoscanWeb.Endpoint, :broadcast, ["room:home", "change", payload])
    end

    {:noreply, state}
  catch
    _, _ ->
      Logger.warn("PubSub is not started yet")
      {:noreply, state}
  end

  defp get_blocks do
    blocks = Enum.take(Cache.get_blocks() || [], 5)

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
    transactions = Enum.take(Cache.get_transactions() || [], 5)

    Enum.map(
      transactions,
      &%{
        txid: Base.encode16(&1.hash, case: :lower),
        type: &1.type,
        time: DateTime.to_unix(&1.block_time)
      }
    )
  end
end
