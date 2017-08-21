defmodule NeoscanSync.Producer do
  use GenStage

  alias NeoscanSync.Blockchain
  alias NeoscanSync.HttpCalls
  alias NeoscanMonitor.Api
  alias Neoscan.Blocks

  def start_link() do
    { :ok, counter } = Blocks.get_highest_block_in_db()
    GenStage.start_link(__MODULE__, counter, name: __MODULE__)
  end

  def init(counter), do: {:producer, {counter, 0}}

  def handle_info(:fetch_more, {counter, pending_demand}) do
    do_handle_demand(pending_demand, {counter, 0})
  end

  def handle_demand(demand, {counter, pending_demand}) do
    do_handle_demand(demand, {counter, pending_demand})
  end

  def do_handle_demand(demand, {counter, _pending_demand}) do
    events = get_current_height()
    |> evaluate(demand, counter+1)

    events_count = Enum.count(events)
    check_if_demand(  events_count, demand)
    {:noreply, events, {(counter + events_count), demand - events_count}}
  end

  def check_if_demand(events, demand) when events < demand do
    Process.send_after(self(), :fetch_more, 15000)
  end
  def check_if_demand(events, demand) when events == demand do
    IO.puts("demand fullfiled")
  end

  #evaluate number of process, current block count, and start async functions
  defp evaluate(result, n, count) do
    case result do
      {:ok, height} when (height) > count  ->
        cond do
          height  - count >= n ->
            Enum.to_list(count..(count+n-1))
            |> Enum.map(&Task.async(fn -> cross_check(&1) end))
            |> Enum.map(&Task.await(&1, 60*60*1000))
          height  - count < n ->
            Enum.to_list(count..(height))
            |> Enum.map(&Task.async(fn -> cross_check(&1) end))
            |> Enum.map(&Task.await(&1, 60*60*1000))
        end
      {:ok, height} when (height) == count  ->
        []
      {:ok, height} when (height) < count  ->
        []
    end
  end

  #cross check block hash between different seeds
  def cross_check(height) do
    nodes = check_if_nodes(2)
    cond do
      nodes != nil ->
        [random1, random2] = nodes
        blockA = get_block_by_height(random1, height)
        blockB = get_block_by_height(random2, height)
        cond do
          blockA == blockB ->
            blockA
          true ->
            cross_check(height)
        end
      true ->
        cross_check(height)
    end
  end

  defp check_if_nodes(n) do
    nodes = HttpCalls.url(n)
    cond do
      Enum.count(nodes) == n ->
        nodes
      true ->
        Process.sleep(60000)
        nil
    end
  end

  #handles error when fetching block from chain
  def get_block_by_height(nil, height) do
    get_block_by_height(check_if_nodes(1), height)
  end
  def get_block_by_height(random, height) do
    case Blockchain.get_block_by_height(random, height) do
      { :ok , block } ->
        block
      { :error, _reason} ->
        get_block_by_height(check_if_nodes(1), height)
    end
  end

  #get current height from monitor
  def get_current_height() do
    Api.get_height
    #{ :ok, 5000}
  end
end
