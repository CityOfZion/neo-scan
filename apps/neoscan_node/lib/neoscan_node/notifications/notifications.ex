defmodule NeoscanNode.Notifications do
  use HTTPoison.Base

  @moduledoc """
  The boundary for the notification requests.
  """

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

  def get_url(urls_tried) do
    list = Application.fetch_env!(:neoscan_node, :notification_seeds) -- urls_tried

    case list do
      [] ->
        nil

      not_empty_list ->
        not_empty_list
        |> Enum.random()
    end
  end

  defp check_token({:ok, result, _current_height}) do
    result
  end

  defp check_token(_response) do
    Logger.info("error getting notifications for tokens")
    {:error, "error getting notifications"}
  end

  defp check({:ok, result, current_height}, height, _url) do
    cond do
      current_height - 1 < height ->
        get_block_notifications(height)

      current_height - 1 >= height ->
        result
    end
  end

  defp check(_response, height, urls_tried) do
    Logger.info("error getting notifications for block #{height}")
    get_block_notifications(height, urls_tried)
  end
end
