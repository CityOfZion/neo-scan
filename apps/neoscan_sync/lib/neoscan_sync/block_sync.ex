defmodule NEOScanSync.BlockSync do

  alias Neoscan.Blockchain
  alias Neoscan.Blocks
  alias Neoscan.Transactions

  @me __MODULE__

  def start_link() do
    Agent.start_link(fn -> start() end , name: @me)
  end

  def change_seed(seed) do
    start(seed)
  end

  def start(seed \\ 0) do
    case Blocks.get_highest_block_in_db() do
      nil ->
        { :ok, block } = Blockchain.get_block_by_height(%{:index => seed, :height => 1 })
        add_block(block)
        start(seed)
      { :ok, %{:height => count}} ->
        evaluate(count, seed)
        start(seed)
    end
  end

  def evaluate(count, seed) do
    case Blockchain.get_current_height(%{:index => seed}) do
      {:ok, height} when height > count  ->
        { :ok, block } = Blockchain.get_block_by_height(%{:index => seed, :height => count+1 })
        add_block(block)
        start(seed)
      {:ok, height} when height == count  ->
        :timer.sleep(15000)
        start(seed)
      {:ok, height} when height < count ->
        Blocks.delete_higher_than(height)
        :timer.sleep(15000)
        start(seed)
    end
  end

  def add_block(block) do
    %{"tx" => transactions, "index" => n} = block
    Map.delete(block, "tx")
    IO.inspect(block)
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    IO.puts("Block #{n} stored")
  end

end
