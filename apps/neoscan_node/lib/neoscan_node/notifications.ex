defmodule NeoscanNode.Notifications do
  @moduledoc """
  The boundary for the notification requests.
  """

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)
  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)
  @retry_interval 1_000

  alias NeoscanNode.HttpCalls
  require Logger

  defp get_servers() do
    notification_server = System.get_env("NEO_NOTIFICATIONS_SERVER")
    if is_nil(notification_server), do: @notification_seeds, else: [notification_server]
  end

  defp get_url(urls_tried) do
    remaining_urls = get_servers() -- urls_tried
    unless remaining_urls == [], do: Enum.random(remaining_urls)
  end

  def get_block_notifications(height, urls_tried \\ []) do
    url = get_url(urls_tried)

    case url do
      nil ->
        Logger.info("tried all endpoints")
        {:error, "no working rpc endpoint"}

      _ ->
        "#{url}/notifications/block/#{height}"
        |> HttpCalls.get()
        |> check(height, [url | urls_tried])
    end
  end

  def get_token_notifications(urls_tried \\ []) do
    url = get_url(urls_tried)
    result = HttpCalls.get("#{url}/tokens")

    case result do
      {:ok, result2, _current_height} ->
        result2

      _ ->
        Logger.info("error getting notifications for tokens")
        {:error, "error getting notifications"}
    end
  end

  defp check({:ok, _result, current_height}, height, _url) when current_height - 1 < height do
    get_block_notifications(height)
  end

  defp check({:ok, result, _}, _, _), do: result

  defp check(_response, height, urls_tried) do
    Logger.info("error getting notifications for block #{height}")
    get_block_notifications(height, urls_tried)
  end

  def add_notifications(block, height) do
    # Disable notification checks for less than first ever nep5 token issue block height
    transfers =
      if height > @limit_height do
        get_notifications(height)
        |> Enum.filter(fn %{"notify_type" => t} -> t == "transfer" end)
      else
        []
      end

    Map.merge(block, %{"transfers" => transfers})
  end

  defp get_notifications(height) do
    case get_block_notifications(height) do
      {:error, _} ->
        Process.sleep(@retry_interval)
        get_notifications(height)

      result ->
        result
    end
  end
end
