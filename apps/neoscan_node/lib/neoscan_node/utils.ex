defmodule NeoscanNode.Utils do
  def pmap(collection, func, timeout) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&(Task.yield(&1, timeout) || Task.shutdown(&1)))
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :ok))
    |> Enum.map(fn {:ok, result} -> result end)
  end
end
