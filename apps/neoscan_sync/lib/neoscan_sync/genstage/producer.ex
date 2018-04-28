defmodule NeoscanSync.Producer do
  @moduledoc false
  use GenStage

  alias NeoscanSync.Blockchain
  alias NeoscanSync.Notifications
  alias NeoscanSync.HttpCalls
  alias NeoscanMonitor.Api
  alias Neoscan.Blocks

  require Logger

  def start_link do
    {:ok, counter} = Blocks.get_highest_block_in_db()
    GenStage.start_link(__MODULE__, counter, name: __MODULE__)
  end

  def init(counter), do: {:producer, {counter, 0}}

  def handle_info(:fetch_more, {counter, pending_demand}) do
    Logger.info("#{pending_demand} blocks pending")
    do_handle_demand(pending_demand, {counter, 0})
  end

  def handle_demand(demand, {counter, pending_demand}) do
    do_handle_demand(demand, {counter, pending_demand})
  end

  def do_handle_demand(demand, {counter, _pending_demand}) do
    events =
      get_current_height()
      |> evaluate(demand, counter + 1)

    events_count = Enum.count(events)
    check_if_demand(events_count, demand)
    {:noreply, events, {counter + events_count, demand - events_count}}
  end

  def check_if_demand(events, demand) when events < demand do
    Process.send_after(self(), :fetch_more, 15_000)
  end

  def check_if_demand(events, demand) when events == demand do
    Logger.info("demand fullfiled, actual: #{inspect(demand)}, Events: #{inspect(events)}")
  end

  # evaluate number of process, current block count, and start async functions
  defp evaluate(result, n, count) do
    case result do
      {:ok, height} when height > count ->
        if height - count >= n do
          Enum.to_list(count..(count + n - 1))
          |> Enum.map(&Task.async(fn -> cross_check(&1) end))
          |> Enum.map(&Task.await(&1, 60 * 60 * 1000))
          |> Enum.filter(fn b -> Map.has_key?(b, "nextblockhash") end)
        else
          Enum.to_list(count..height)
          |> Enum.map(&Task.async(fn -> cross_check(&1) end))
          |> Enum.map(&Task.await(&1, 60 * 60 * 1000))
          |> Enum.filter(fn b -> Map.has_key?(b, "nextblockhash") end)
        end

      {:ok, height} when height == count ->
        []

      {:ok, height} when height < count ->
        []
    end
  end

  # cross check block hash between different seeds
  defp cross_check(height) do
    nodes = check_if_nodes(2)

    if nodes != nil do
      [random1, random2] = nodes
      block_a = get_block_by_height(random1, height)
      block_b = get_block_by_height(random2, height)

      if block_a == block_b do
        add_notifications(block_a, height)
      else
        # cross_check(height)
        Logger.info("Blocks don't match!")
        add_notifications(block_a, height)
      end
    else
      cross_check(height)
    end
  end

  defp check_if_nodes(n) do
    nodes = HttpCalls.url(n)

    if Enum.count(nodes) == n do
      nodes
    else
      Supervisor.terminate_child(
        NeoscanMonitor.Supervisor,
        NeoscanMonitor.Worker
      )

      Supervisor.restart_child(NeoscanMonitor.Supervisor, NeoscanMonitor.Worker)
      Process.sleep(5000)
      nil
    end
  end

  # handles error when fetching block from chain
  defp get_block_by_height(nil, height) do
    [url] = check_if_nodes(1)
    get_block_by_height(url, height)
  end

  defp get_block_by_height(random, height) do
    case Blockchain.get_block_by_height(random, height) do
      {:ok, block} ->
        block

      {:error, _reason} ->
        [url] = check_if_nodes(1)
        get_block_by_height(url, height)
    end
  end

  # get current height from monitor
  def get_current_height do
    Api.get_height()
  end

  def add_notifications(block, height) do
    # Disable notification checks for less than first ever nep5 token issue block height
    limit_height = Application.fetch_env!(:neoscan_sync, :start_notifications)

    transfers =
      cond do
        height > limit_height ->
          get_notifications(height)
          |> Enum.filter(fn %{"notify_type" => t} -> t == "transfer" end)

        height <= limit_height ->
          []
      end

    Map.merge(block, %{"transfers" => transfers})
  end

  def get_notifications(height) do
    case Notifications.get_block_notifications(height) do
      {:error, _} ->
        get_notifications(height)

      result ->
        result
    end
  end
end
