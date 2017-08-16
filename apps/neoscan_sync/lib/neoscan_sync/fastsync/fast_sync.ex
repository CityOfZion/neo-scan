defmodule NeoscanSync.FastSync do
  @moduledoc false

  @moduledoc """

    External process to fetch blockchain from RCP node sync, and print json

  """

  alias NeoscanSync.Blockchain
  alias NeoscanSync.HttpCalls
  alias Neoscan.Pool
  alias NeoscanSync.BlockSync
  alias NeoscanMonitor.Api

  @me __MODULE__
  #Starts the application
  def start_link() do
    pid = spawn_link( @me, start(), [])
    {:ok, pid}
  end

  #Start process, create file and get current height from the chain
  def start(n \\ 400) do
    count = Pool.get_highest_block_in_pool()
    fetch_chain(n, count)
  end

  def check_process() do
    alive = Process.whereis(Neoscan.Supervisor)
    |> Process.alive?
    case alive do
      true ->
        true
      false ->
        IO.puts("Main process was killed")
        Process.exit(self(), :shutdown)
    end
  end

  def fetch_chain(n, count) do
    check_process()
    get_current_height()
    |> evaluate(n, count+1)
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
            |> Enum.map(fn x -> add_block(x) end)
            fetch_chain(n, count+n-1)
          height  - count < n ->
            Enum.to_list(count..(height))
            |> Enum.map(&Task.async(fn -> cross_check(&1) end))
            |> Enum.map(&Task.await(&1, 60*60*1000))
            |> Enum.map(fn x -> add_block(x) end)
            BlockSync.start()
        end
      {:ok, height} when (height) == count  ->
        BlockSync.start()
      {:ok, height} when (height) < count  ->
        start(n)
    end
  end

  #write block to the file
  def add_block(%{"index" => num} = block) do
    cond do
      block["nextblockhash"] != nil ->
        %{"height" => num, "block" => block}
        |> Pool.create_data()
        IO.puts("Block #{num} saved in pool")
      true ->
        BlockSync.start()
    end

  end

  #cross check block hash between different seeds
  def cross_check(height) do
    [random1, random2] = HttpCalls.url(2)
    blockA = get_block_by_height(random1, height)
    blockB = get_block_by_height(random2, height)
    cond do
      blockA == blockB ->
        blockA
      true ->
        cross_check(height)
    end
  end


  #handles error when fetching block from chain
  def get_block_by_height(random, height) do
    case Blockchain.get_block_by_height(random, height) do
      { :ok , block } ->
        block
      { :error, _reason} ->
        get_block_by_height(HttpCalls.url(1), height)
    end
  end

  #handles error when fetching height from chain
  def get_current_height() do
    Api.get_height
  end

end
