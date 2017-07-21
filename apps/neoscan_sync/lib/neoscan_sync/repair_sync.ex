defmodule NEOScanSync.RepairSync do
  @moduledoc """

    External process to fetch blockchain from RCP node and sync the database

  """

  alias Neoscan.Blockchain
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Transactions.Transaction

  @me __MODULE__

  #Starts the application
  def start_link() do
    Agent.start_link(fn -> start() end , name: @me)
  end

  #receives external orders to change the main seed, seed is the integer of the
  #corresponding seed, as defined in the Neoscan.Http module


  #check if main endpoint is alive, otherwise shutdown process
  def start(seed \\ 0) do
    alive = Process.whereis(Neoscan.Supervisor)
    |> Process.alive?
    case alive do
      true ->
        fetch_db(seed, 0)
      false ->
        IO.puts("Main process was killed")
        Process.exit(self(), :shutdown)
    end
  end

  #get highest block from db and route functions forward
  def fetch_db(seed, n) do
    highest = Blocks.get_highest_block_in_db
    case Blocks.get_block_by_height(n) do
      nil ->
        get_block_by_height(seed, 0)
        |> add_block(seed)
      { :ok, %Blocks.Block{:index => count}} ->
        cond do
          count == highest ->
            Process.sleep(300000)
            start()
          count < highest ->
            fetch_db(seed, n+1)
        end
      { :error, reason} ->
        IO.puts("Failed to get highest block from db, result =#{reason}")
        Process.exit(self(), :error)
    end
  end

  #add block with transactions to the db
  def add_block(%{"tx" => transactions, "index" => n} = block, seed) do
    Map.put(block,"tx_count",Kernel.length(transactions))
    |> Map.delete("tx")
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    |> check(seed,n)
  end

  def check(r, seed, n) do
    cond do
      {:ok, "Created"} == r or {:ok, "Deleted"} == r ->
        IO.puts("Block #{n} repaired")
        repair_balances()
        start(seed)
      true ->
        IO.puts("Failed to create transactions")
        Blocks.get_block_by_height(n)
        |> Blocks.delete_block()
        IO.inspect(r)
        Process.exit(self(), :error)
    end
  end

  #handles error when fetching highest block from chain
  def get_block_by_height(seed, index) do
    case Blockchain.get_block_by_height(seed, index) do
      { :ok , block } ->
        block
      { :error, :timeout} ->
        Process.sleep(5000)
        start(seed)
      { :error, reason} ->
        IO.puts("Failed to get block from chain, result =#{reason}")
        Process.exit(self(), :error)
    end
  end

  def repair_balances() do
    ## TODO
    Repo.all(Transaction)
    |> Enum.map(fn x -> x end)
  end

end
