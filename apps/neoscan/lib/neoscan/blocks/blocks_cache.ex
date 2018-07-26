defmodule Neoscan.BlocksCache do
  @moduledoc """
  Provide a cache for the block fees, it uses a binary structure stored in a file for efficiency reason.
  """

  use GenServer
  alias Neoscan.Blocks
  alias Neoscan.SegmentTree

  @timeout 60_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, %{min: nil, max: nil, segment_tree: %{}}}
  end

  def get_sys_fees_in_range(_, -1), do: 0

  def get_sys_fees_in_range(min, max) do
    GenServer.call(__MODULE__, {:range, min, max}, @timeout)
  end

  defp update_segment_tree(segment_tree, blocks) do
    Enum.reduce(blocks, segment_tree, fn %{index: index, total_sys_fee: value}, acc ->
      SegmentTree.insert_value(acc, index, value)
    end)
  end

  @impl true
  def handle_call(
        {:range, min, max},
        _from,
        %{min: nil, max: nil, segment_tree: segment_tree} = state
      ) do
    blocks = Blocks.get_total_sys_fee(min, max)

    state =
      if Enum.count(blocks) == max - min + 1 do
        %{
          segment_tree: update_segment_tree(segment_tree, blocks),
          min: min,
          max: min + Enum.count(blocks) - 1
        }
      else
        state
      end

    {:reply, SegmentTree.sum(state.segment_tree, min, max), state}
  end

  def handle_call(
        {:range, min, max},
        _from,
        %{min: cache_min, max: cache_max, segment_tree: segment_tree} = state
      ) do
    blocks1 = Blocks.get_total_sys_fee(min, cache_min)
    blocks2 = Blocks.get_total_sys_fee(cache_max + 1, max)

    state =
      if Enum.count(blocks1) == max(cache_min - min + 1, 0) and
           Enum.count(blocks2) == max(max - cache_max, 0) do
        segment_tree = update_segment_tree(update_segment_tree(segment_tree, blocks1), blocks2)
        %{segment_tree: segment_tree, min: min, max: cache_max + Enum.count(blocks2)}
      else
        state
      end

    {:reply, SegmentTree.sum(state.segment_tree, min, max), state}
  end
end
