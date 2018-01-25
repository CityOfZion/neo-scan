defmodule NeoscanSync.Consumer do
  @moduledoc false
  use GenStage
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Transfers

  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    {
      :consumer,
      state,
      subscribe_to: [{NeoscanSync.Producer, max_demand: 100, min_demand: 50}]
    }
  end

  def handle_events(events, _from, state) do
    for event <- events do
      add_block(event)
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end

  # add block with transactions to the db
  def add_block(%{"tx" => transactions, "index" => height, "time" => time, "transfers" => tf} = block) do
    Map.put(block, "tx_count", Kernel.length(transactions))
    |> Blocks.compute_fees()
    |> Map.delete("tx")
    |> Map.delete("transfers")
    |> Blocks.create_block()
    |> Transactions.create_transactions(transactions)
    |> check(tf, height)
    |> Transfers.add_block_transfers(time)
    |> check_final(height)
  end

  defp check({:ok, "Created", block}, transfers, _height) do
    {block, transfers}
  end
  defp check({:ok, "Deleted", block}, transfers, _height) do
    {block, transfers}
  end
  defp check(_, _transfers, height) do
    Logger.info("Failed to create transactions")

    Blocks.get_block_by_height(height)
    |> Blocks.delete_block()
  end

  defp check_final(r, height) do
    if {:ok, "all operations were succesfull"} == r do
      Logger.info("Block #{height} stored")
    else
      Logger.info("Failed to create transactions")
      Blocks.get_block_by_height(height)
      |> Blocks.delete_block()
    end
  end
end
