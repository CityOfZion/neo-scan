defmodule NeoscanSync.ProducerConsumer do
  use GenStage
  alias Neoscan.Blocks

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [{NeoscanSync.Producer, max_demand: 200, min_demand: 100}]}
  end

  def handle_events(events, _from, state) do
    new_events = Enum.map(events, fn block ->
      add_block(block)
    end)

    {:noreply, new_events, state}
  end

  #add block with transactions to the db
  defp add_block(%{"tx" => transactions} = block) do
    struct = Map.put(block,"tx_count",Kernel.length(transactions))
    |> Map.delete("tx")
    |> Blocks.create_block()

    {block, struct}
  end
end
