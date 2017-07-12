defmodule NEOScanSync.BlockSync do
  @moduledoc """

    External process to fetch blockchain from RCP node and sync the database

  """

  alias Neoscan.Blockchain
  alias Neoscan.Blocks
  alias Neoscan.Transactions

  @me __MODULE__

  #Starts the application
  def start_link() do
    Agent.start_link(fn -> start() end , name: @me)
  end

  #receives external orders to change the main seed, seed is the integer of the
  #corresponding seed, as defined in the Neoscan.Http module
  def change_seed(seed) do
    start(seed)
  end


  #main function, reads and sync the db
  def start(seed \\ 0) do
    case Blocks.get_highest_block_in_db() do
      nil ->
        get_block_by_height(seed, 1)
        |> add_block()
        start(seed)
      { :ok, %{:height => count}} ->
        evaluate(count, seed)
        start(seed)
      { :error, _reason} ->
        Process.whereis(@me)
        |> Process.exit(:error)
    end
  end

  #Evaluates db against external blockchain and route required functions
  def evaluate(count, seed) do
    case Blockchain.get_current_height(%{:index => seed}) do
      {:ok, height} when height > count  ->
        get_block_by_height( seed, count+1 )
        |> add_block()
        start(seed)
      {:ok, height} when height == count  ->
        :timer.sleep(15000)
        start(seed)
      {:ok, height} when height < count ->
        Blocks.delete_higher_than(height)
        :timer.sleep(15000)
        start(seed)
      { :error , _reason } ->
        Process.whereis(@me)
        |> Process.exit(:error)
    end
  end

  #add block with transactions to the db
  def add_block(block) do
    %{"tx" => transactions, "index" => n} = block
    Map.delete(block, "tx")
    IO.inspect(block)
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    IO.puts("Block #{n} stored")
  end

  #handles error when fetching highest block from db
  def get_block_by_height(seed, index) do
    case Blockchain.get_block_by_height(%{:index => seed, :height => index }) do
      { :ok , block } ->
        block
      { :error, _reason} ->
        Process.whereis(@me)
        |> Process.exit(:error)
    end
  end

end
