defmodule NeoscanNode.Notifications do
  use HTTPoison.Base

  @moduledoc """
  The boundary for the notification requests.
  """

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)
  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  alias NeoscanNode.HttpCalls
  require Logger

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
    "#{get_url(urls_tried)}/tokens"
    |> HttpCalls.get()
    |> check_token()
  end

  defp get_servers() do
    notification_server = System.get_env("NEO_NOTIFICATIONS_SERVER")
    if is_nil(notification_server), do: @notification_seeds, else: [notification_server]
  end

  defp get_url(urls_tried) do
    case get_servers() -- urls_tried do
      [] ->
        nil

      not_empty_list ->
        Enum.random(not_empty_list)
    end
  end

  defp check_token({:ok, result, _current_height}) do
    result
  end

  defp check_token(_response) do
    Logger.info("error getting notifications for tokens")
    {:error, "error getting notifications"}
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
        get_notifications(height)

      result ->
        result
    end
  end
end
