defmodule NeoscanNode.NodeChecker do
  @moduledoc false

  @neo_node_urls Application.fetch_env!(:neoscan_node, :seeds)
  @neo_notification_urls Application.fetch_env!(:neoscan_node, :notification_seeds)
  @update_interval 2_000
  @env_var_prefix "NEO_SEED_"
  @env_var_neo_notification "NEO_NOTIFICATIONS_SERVER"
  @retry_interval 1_000

  alias NeoscanNode.EtsProcess
  use GenServer
  require Logger

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

    live_nodes =
      get_neo_node_urls()
      |> pmap(&get_node_height/1, 15_000)
      |> Enum.filter(&(not is_nil(&1)))

    live_notifications =
      get_neo_notification_urls()
      |> pmap(&get_notification_height/1, 15_000)
      |> Enum.filter(&(not is_nil(&1)))

    last_block_index = Enum.max(Enum.map(live_nodes, &elem(&1, 1)), fn -> 0 end)
    set(:last_block_index, last_block_index)
    set(:live_nodes, live_nodes)
    set(:live_notifications, live_notifications)
  end

  def handle_info(:sync, _), do: {:noreply, sync()}

  def get_last_block_index, do: get(:last_block_index)

  def get_live_nodes, do: get(:live_nodes)

  defp get_live_notifications, do: get(:live_notifications)

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

  defp get_neo_node_urls do
    1..20
    |> Enum.map(&"#{@env_var_prefix}#{&1}")
    |> Enum.map(&System.get_env/1)
    |> Enum.filter(&(not is_nil(&1) and &1 != ""))
    |> (&if(&1 == [], do: @neo_node_urls, else: &1)).()
  end

  defp get_neo_notification_urls do
    notification_server = System.get_env(@env_var_neo_notification)

    if is_nil(notification_server) or notification_server == "",
      do: @neo_notification_urls,
      else: [notification_server]
  end

  defp get_notification_height(url) do
    case NeoNotification.get_current_height(url) do
      nil ->
        nil

      height ->
        {url, height}
    end
  end

  defp get_node_height(url) do
    {status, count} = NeoNode.get_block_count(url)

    if status == :ok do
      try do
        height = count - 1
        {status, _block} = NeoNode.get_block_by_height(url, height)

        if status == :ok do
          {url, height}
        end
      rescue
        e in FunctionClauseError ->
          Logger.error("error: #{url} #{inspect(e)}}")
          nil
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

  def set(key, value), do: :ets.insert(__MODULE__, {key, value})

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end
end
