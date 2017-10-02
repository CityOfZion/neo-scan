defmodule NeoscanMonitor.Utils do
  alias NeoscanSync.Blockchain

  def seeds do
    [
      "http://seed1.cityofzion.io:8080",
      "http://seed2.cityofzion.io:8080",
      "http://seed3.cityofzion.io:8080",
      "http://seed4.cityofzion.io:8080",
      "http://seed5.cityofzion.io:8080",
      "http://api.otcgo.cn:10332",
      "http://seed1.neo.org:10332",
      "http://seed2.neo.org:10332",
      "http://seed3.neo.org:10332",
      "http://seed4.neo.org:10332",
      "http://seed5.neo.org:10332"
    ]
  end

  def load do
    data = seeds()
           |> Enum.map(fn url -> {url, Blockchain.get_current_height(url)} end)
           |> Enum.filter(fn {url, result} -> evaluate_result(url, result)  end)
           |> Enum.map(fn {url, {:ok, height}} -> {url, height} end)

    set_state(data)
  end

  defp set_state([] = data) do
    %{:nodes => [], :height => {:ok, nil}, :data => data}
  end
  defp set_state(data) do
    height = filter_height(data)
    %{:nodes => filter_nodes(data, height), :height => {:ok, height}, :data => data}
  end

  defp filter_nodes(data, height) do
    data
    |> Enum.filter(fn {_url, hgt} -> hgt == height end)
    |> Enum.map(fn {url, _height} -> url end)
  end

  defp filter_height(data) do
    {height, _count} = data
                       |> Enum.map(fn {_url, height} -> height end)
                       |> Enum.reduce(%{}, fn (height, acc) -> Map.update(acc, height, 1, &(&1 + 1)) end)
                       |> Enum.max_by(fn {_height, count} -> count end)
    height
  end

  defp evaluate_result(url, {:ok, height}) do
    test_get_block(url, height)
  end
  defp evaluate_result(_url, {:error, _height}) do
    false
  end

  defp test_get_block(url, height) do
    Blockchain.get_block_by_height(url, height - 1)
    |> test()
  end

  defp test({:ok, _block}) do
    true
  end
  defp test({:error, _reason}) do
    false
  end

end
