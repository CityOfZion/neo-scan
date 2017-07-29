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
    alive = Process.whereis(Neoscan.Supervisor)
    |> Process.alive?
    case alive do
      true ->
        fetch_db()
      false ->
        IO.puts("Main process was killed")
        Process.exit(self(), :shutdown)
    end
  end

  #get highest block from db and route functions forward
  def fetch_db() do
    case Blocks.get_highest_block_in_db() do
      nil ->
        get_block_from_pool(0)
        |> add_block()
      { :ok, %Blocks.Block{:index => count}} ->
        evaluate(count)
      { :error, reason} ->
        IO.puts("Failed to get highest block from db, result =#{reason}")
        fetch_db()
    end
  end

  #Evaluates db against external blockchain and route required functions
  def evaluate(count) do
    case Pool.get_highest_block_in_pool do
      height when height > count  ->
        get_block_from_pool( count+1 )
        |> add_block()
      height when height == count  ->
        FastSync.start()
      height when height < count ->
        Blocks.delete_higher_than(height)
        FastSync.start()
      nil ->
        FastSync.start()
    end
  end

  #add block with transactions to the db
  def add_block(%{"tx" => transactions, "index" => n} = block) do
    Map.put(block,"tx_count",Kernel.length(transactions))
    |> Map.delete("tx")
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    |> check(n)
  end

  def check(r, n) do
    cond do
      {:ok, "Created"} == r or {:ok, "Deleted"} == r ->
        IO.puts("Block #{n} stored")
        start()
      true ->
        IO.puts("Failed to create transactions")
        Blocks.get_block_by_height(n)
        |> Blocks.delete_block()
        start()
    end
  end


  #handles error when fetching highest block from chain
  def get_block_from_pool(height) do
    case Pool.get_block_in_pool(height) do
      %{} = block ->
        block
      nil ->
        block = FastSync.cross_check(height)
        FastSync.add_block(block)
        add_block(block)
        start()
    end
  end

end
