defmodule NeoscanNode.NodeChecker do
  @moduledoc false

  @servers Application.fetch_env!(:neoscan_node, :seeds)
  @update_interval 2_000
  @env_vars ["NEO_SEED_1", "NEO_SEED_2", "NEO_SEED_3", "NEO_SEED_4"]

  alias NeoscanNode.Blockchain
  alias NeoscanNode.EtsProcess

  use GenServer

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    EtsProcess.create_table(__MODULE__)
    {:ok, sync()}
  end

  def sync() do
    Process.send_after(self(), :sync, @update_interval)

    data =
      get_servers()
      |> pmap(&get_node_height/1, 15_000)
      |> Enum.filter(&(not is_nil(&1)))

    height = get_common_height(data)
    set(:nodes, filter_nodes_by_height(data, height))
    set(:height, {:ok, height})
    set(:data, data)
  end

  def handle_info(:sync, _), do: {:noreply, sync()}

  def get_nodes, do: get(:nodes)

  def get_height, do: get(:height)

  def get_data, do: get(:data)

  def get_random_node do
    nodes = get_nodes()

    if Enum.empty?(nodes) do
      Process.sleep(1_000)
      get_random_node()
    else
      Enum.random(nodes)
    end
  end

  defp get_servers do
    @env_vars
    |> Enum.map(&System.get_env/1)
    |> Enum.filter(&(not is_nil(&1)))
    |> (&if(&1 == [], do: @servers, else: &1)).()
  end

  defp get_node_height(url) do
    {status, height} = Blockchain.get_current_height(url)

    if status == :ok do
      {status, _block} = Blockchain.get_block_by_height(url, height - 1)

      if status == :ok do
        {url, height}
      end
    end
  end

  defp pmap(collection, func, timeout) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&(Task.yield(&1, timeout) || Task.shutdown(&1)))
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :ok))
    |> Enum.map(fn {:ok, result} -> result end)
  end

  # filter working nodes
  defp filter_nodes_by_height(data, height) do
    data
    |> Enum.filter(fn {_url, hgt} -> hgt == height end)
    |> Enum.map(fn {url, _height} -> url end)
  end

  # filter current height
  defp get_common_height([]), do: 0

  defp get_common_height(data) do
    {height, _count} =
      data
      |> Enum.group_by(fn {_url, height} -> height end)
      |> Enum.map(fn {height, list} -> {height, Enum.count(list)} end)
      |> Enum.max_by(fn {_height, count} -> count end)

    height
  end

  def set(key, value), do: :ets.insert(__MODULE__, {key, value})

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end
end
