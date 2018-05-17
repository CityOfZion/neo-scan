defmodule NeoscanSync.Consumer do
  @moduledoc false
  use GenStage
  alias Neoscan.Blocks

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    demand = Application.fetch_env!(:neoscan_sync, :demand_size)

    {
      :consumer,
      state,
      subscribe_to: [{NeoscanSync.Producer, max_demand: demand, min_demand: round(demand / 2)}]
    }
  end

  def handle_events(events, _from, state) do
    Enum.each(events, &Blocks.add_block/1)
    {:noreply, [], state}
  end
end
