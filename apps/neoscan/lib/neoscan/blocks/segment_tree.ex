defmodule Neoscan.SegmentTree do
  @moduledoc """
  Data structure to compute efficiently ranges
  """

  @max 4_194_304 - 1

  def insert_value(tree, index, value) do
    insert_value(tree, 0, 0, @max, index, value)
  end

  def insert_value(tree, tree_index, min, min, _, value), do: Map.put(tree, tree_index, value)

  def insert_value(tree, tree_index, min, max, index, value) do
    new_tree = Map.update(tree, tree_index, value, &(&1 + value))
    mid = min + round((max - min + 1) / 2)

    if index < mid do
      insert_value(new_tree, tree_index * 2 + 1, min, mid - 1, index, value)
    else
      insert_value(new_tree, tree_index * 2 + 2, mid, max, index, value)
    end
  end

  def sum(tree, scan_min, scan_max) do
    sum(tree, 0, 0, @max, scan_min, scan_max)
  end

  def sum(_, _, min, max, scan_min, scan_max) when max < scan_min or min > scan_max, do: 0

  def sum(tree, tree_index, min, max, scan_min, scan_max)
      when scan_min <= min and max <= scan_max,
      do: Map.get(tree, tree_index, 0)

  def sum(tree, tree_index, min, max, scan_min, scan_max) do
    mid = min + round((max - min + 1) / 2)

    sum(tree, tree_index * 2 + 1, min, mid - 1, scan_min, scan_max) +
      sum(tree, tree_index * 2 + 2, mid, max, scan_min, scan_max)
  end
end
