defmodule NeoscanNode.Worker do
  @moduledoc """
  GenServer module responsable to store blocks, states, trasactions and assets,
  Common interface to handle it is NeoscanMonitor.Api module(look there for more info)
  """

  @servers Application.fetch_env!(:neoscan_node, :seeds)
  @update_interval 10_000

  alias NeoscanNode.Blockchain

  use GenServer

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_nodes do
    Map.get(get(:monitor), :nodes)
  end

  def get_height do
    Map.get(get(:monitor), :height)
  end

  def get_data do
    Map.get(get(:monitor), :data)
  end

  defp get_servers do
    ["NEO_SEED_1", "NEO_SEED_2", "NEO_SEED_3", "NEO_SEED_4"]
    |> Enum.map(&System.get_env/1)
    |> Enum.filter(&(not is_nil(&1)))
    |> (&if(&1 == [], do: @servers, else: &1)).()
  end

  # function to load nodes state
  def load do
    data =
      get_servers()
      |> pmap(fn url ->
        current_height = Blockchain.get_current_height(url)
        {url, current_height, evaluate_result(url, current_height)}
      end)
      |> Enum.filter(fn {_, _, keep} -> keep end)
      |> Enum.map(fn {url, {:ok, height}, _} -> {url, height} end)

    set_state(data)
  end

  defp evaluate_result(url, {:ok, height}) do
    {type, _} = Blockchain.get_block_by_height(url, height - 1)
    type == :ok
  end

  defp evaluate_result(_url, {:error, _height}), do: false

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1, 15_000))
  end

  # handler for nil data
  defp set_state([] = data) do
    %{:nodes => [], :height => {:ok, nil}, :data => data}
  end

  # call filters on results and set state
  defp set_state(data) do
    height = filter_height(data)
    %{nodes: filter_nodes(data, height), height: {:ok, height}, data: data}
  end

  # filter working nodes
  defp filter_nodes(data, height) do
    data
    |> Enum.filter(fn {_url, hgt} -> hgt == height end)
    |> Enum.map(fn {url, _height} -> url end)
  end

  # filter current height
  defp filter_height(data) do
    {height, _count} =
      data
      |> Enum.map(fn {_url, height} -> height end)
      |> Enum.reduce(%{}, fn height, acc ->
        Map.update(acc, height, 1, &(&1 + 1))
      end)
      |> Enum.max_by(fn {_height, count} -> count end)

    height
  end

  def set(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end

  def handle_info(:update_nodes, _), do: {:noreply, sync()}

  def sync() do
    Process.send_after(self(), :update_nodes, @update_interval)
    set(:monitor, load())
  end

  def init(:ok) do
    :ets.new(__MODULE__, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    sync()

    {:ok, nil}
  end
end
