defmodule NeoscanNode.NodeChecker do
  @moduledoc false

  @neo_node_urls Application.fetch_env!(:neoscan_node, :seeds)
  @neo_notification_urls Application.fetch_env!(:neoscan_node, :notification_seeds)
  @update_interval 100
  @env_var_nodes "NEO_SEEDS"
  @env_var_neo_notification "NEO_NOTIFICATIONS_SERVER"
  @retry_interval 1_000
  @timeout 15_000
  @five_minutes 300_000
  @node_list_url Application.fetch_env!(:neoscan_node, :node_list_url)

  alias NeoscanNode.EtsProcess
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

    task =
      Task.async(fn ->
        get_neo_node_urls()
        |> pmap(&get_node_height/1, @timeout)
        |> Enum.filter(&(not is_nil(&1)))
      end)

    live_notifications =
      get_neo_notification_urls()
      |> pmap(&get_notification_height/1, @timeout)
      |> Enum.filter(&(not is_nil(&1)))

    live_nodes = Task.await(task, @timeout)

    last_block_index = Enum.max(Enum.map(live_nodes, &elem(&1, 1)), fn -> 0 end)
    set(:last_block_index, last_block_index)
    set(:live_nodes, live_nodes)
    set(:live_notifications, live_notifications)
  end

  def handle_info(:sync, _), do: {:noreply, sync()}

  def get_last_block_index, do: get(:last_block_index)

  def get_live_nodes, do: get(:live_nodes)

  defp get_live_notifications, do: get(:live_notifications)

  defp process_url_task do
    new_list = Enum.uniq(@neo_node_urls ++ get_node_urls())
    Application.put_env(:neoscan_node, :seeds, new_list)
    Process.sleep(@five_minutes)
    process_url_task()
  end

  def get_random_notification(index) do
    case Enum.filter(get_live_notifications(), &(elem(&1, 1) >= index)) do
      [] ->
        Process.sleep(@retry_interval)
        get_random_notification(index)

      nodes ->
        elem(Enum.random(nodes), 0)
    end
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

  defp get_neo_notification_urls do
    notifications_str = System.get_env(@env_var_neo_notification) || ""

    case String.split(notifications_str, ";") do
      [""] ->
        @neo_notification_urls

      neo_notification_urls ->
        neo_notification_urls
    end
  end

  defp get_notification_height(url) do
    case NeoNotification.get_current_height(url) do
      {:ok, height} ->
        {url, height}

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

  defp pmap(collection, func, timeout) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&(Task.yield(&1, timeout) || Task.shutdown(&1)))
    |> Enum.filter(&(is_tuple(&1) and elem(&1, 0) == :ok))
    |> Enum.map(fn {:ok, result} -> result end)
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
      |> pmap(&keep_correct_version/1, @timeout)
      |> Enum.filter(&(not is_nil(&1)))
    catch
      _, _ ->
        []
    end
  end
end
