defmodule NeoscanSync.BlockSync do
  @moduledoc false

  @moduledoc """

    External process to fetch blockchain from RCP node and sync the database

  """

  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Pool
  alias NeoscanSync.FastSync

  @me __MODULE__

  #Starts the application
  def start_link() do
    Agent.start_link(fn -> start() end , name: @me)
  end

  #check if main endpoint is alive, otherwise shutdown process
  def start() do
    max_block_in_db = Blocks.get_highest_block_in_db()
    max_block_in_pool = Pool.get_highest_block_in_pool
    fetch_db(max_block_in_db, max_block_in_pool)
  end

  def check_process do
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

  #get highest block from db and route functions forward
  def fetch_db(max_block_in_db, max_block_in_pool) do
    case max_block_in_db do
      nil ->
        get_block_from_pool(0, max_block_in_pool)
        |> add_block(0, max_block_in_pool)
      { :ok, count} ->
        evaluate(count, max_block_in_pool)
      { :error, reason} ->
        IO.puts("Failed to get highest block from db, result =#{reason}")
        fetch_db(max_block_in_db, max_block_in_pool)
    end
  end

  #Evaluates db against external blockchain and route required functions
  def evaluate(count, max_block_in_pool) do
    case max_block_in_pool do
      height when height > count ->
        get_block_from_pool( count+1 , max_block_in_pool)
        |> add_block(count+1, max_block_in_pool)
      height when height == count  ->
        Process.sleep(self(), 15000)
        FastSync.start()
      height when height < count ->
        Blocks.delete_higher_than(height)
        Process.sleep(self(), 15000)
        FastSync.start()
      nil ->
        Process.sleep(self(), 15000)
        FastSync.start()
    end
  end

  #add block with transactions to the db
  def add_block(%{"tx" => transactions, "index" => height} = block, count, max_block_in_pool) do
    Map.put(block,"tx_count",Kernel.length(transactions))
    |> Map.delete("tx")
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    |> check(height, count, max_block_in_pool)
  end

  def check(r, height, count, max_block_in_pool) do
    cond do
      {:ok, "Created"} == r or {:ok, "Deleted"} == r ->
        IO.puts("Block #{height} stored")
        evaluate(count, max_block_in_pool)
      true ->
        IO.puts("Failed to create transactions")
        Blocks.get_block_by_height(height)
        |> Blocks.delete_block()
        evaluate(count, max_block_in_pool)
    end
  end


  #handles error when fetching highest block from chain
  def get_block_from_pool(height, max_block_in_pool) do
    case Pool.get_block_in_pool(height) do
      %{} = block ->
        block
      nil ->
        block = FastSync.cross_check(height)
        FastSync.add_block(block)
        evaluate(height-1, max_block_in_pool)
    end
  end

end
