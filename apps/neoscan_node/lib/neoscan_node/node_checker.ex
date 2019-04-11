defmodule NeoscanNode.NodeChecker do
  @moduledoc false

  @node_list_url Application.fetch_env!(:neoscan_node, :node_list_url)
  @neo_node_urls Application.fetch_env!(:neoscan_node, :seeds)
  @update_interval 100
  @env_var_nodes "NEO_SEEDS"
  @retry_interval 1_000
  @timeout 15_000
  @five_minutes 300_000
  @invalid_hash "00"

  alias NeoscanNode.EtsProcess
  alias NeoscanNode.Utils
  use GenServer
  require Logger

  # starts the genserver
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    EtsProcess.create_table(__MODULE__)

    unless has_custom_nodes_conf?() do
      {:ok, _} = Task.start(&process_url_task/0)
    end

    {:ok, sync()}
  end

  def sync() do
    Process.send_after(self(), :sync, @update_interval)

    live_nodes =
      get_neo_node_urls()
      |> Utils.pmap(&get_node_height/1, @timeout)
      |> Enum.filter(&(not is_nil(&1)))

    live_application_log_nodes =
      live_nodes
      |> Utils.pmap(&get_application_log/1, @timeout)
      |> Enum.filter(&(not is_nil(&1)))

    last_block_index = Enum.max(Enum.map(live_nodes, &elem(&1, 1)), fn -> 0 end)
    set(:last_block_index, last_block_index)
    set(:live_nodes, live_nodes)
    set(:live_application_log_nodes, live_application_log_nodes)
  end

  def handle_info(:sync, _), do: {:noreply, sync()}

  def get_last_block_index, do: get(:last_block_index)

  def get_live_nodes, do: get(:live_nodes)

  defp get_live_application_log_nodes, do: get(:live_application_log_nodes)

  defp process_url_task do
    new_list = Enum.uniq(@neo_node_urls ++ get_node_urls())
    Application.put_env(:neoscan_node, :seeds, new_list)
    Process.sleep(@five_minutes)
    process_url_task()
  end

  def get_random_node(index) do
    case Enum.filter(get_live_nodes(), &(elem(&1, 1) >= index)) do
      [] ->
        Process.sleep(@retry_interval)
        get_random_node(index)

      nodes ->
        elem(Enum.random(nodes), 0)
    end
  end

  def get_random_application_log_node(index) do
    case Enum.filter(get_live_application_log_nodes(), &(elem(&1, 1) >= index)) do
      [] ->
        Process.sleep(@retry_interval)
        get_random_application_log_node(index)

      nodes ->
        elem(Enum.random(nodes), 0)
    end
  end

  defp has_custom_nodes_conf?, do: not is_nil(System.get_env(@env_var_nodes))

  defp get_neo_node_urls do
    nodes_str = System.get_env(@env_var_nodes) || ""

    case String.split(nodes_str, ";") do
      [""] ->
        @neo_node_urls

      neo_nodes_urls ->
        neo_nodes_urls
    end
  end

  def get_application_log({url, count}) do
    case NeoNode.get_application_log(url, @invalid_hash) do
      {:error, :invalid_format} ->
        {url, count}

      _ ->
        nil
    end
  end

  defp get_node_height(url) do
    case NeoNode.get_block_count(url) do
      {:ok, count} ->
        {url, count - 1}

      _ ->
        nil
    end
  end

  def set(key, value), do: :ets.insert(__MODULE__, {key, value})

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end

  defp keep_correct_version(url) do
    case NeoNode.get_version(url, 10_000) do
      {:ok, {:csharp, _}} ->
        url

      _ ->
        nil
    end
  end

  def get_node_urls do
    try do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(@node_list_url)
      nodes = Poison.decode!(body)

      nodes["sites"]
      |> Enum.filter(&(&1["type"] == "RPC"))
      |> Enum.map(&"#{&1["protocol"]}://#{&1["url"]}:#{&1["port"] || 80}")
      |> Utils.pmap(&keep_correct_version/1, @timeout)
      |> Enum.filter(&(not is_nil(&1)))
    catch
      _, _ ->
        []
    end
  end
end
