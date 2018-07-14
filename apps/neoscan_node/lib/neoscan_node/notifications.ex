defmodule NeoscanNode.Notifications do
  @moduledoc """
  The boundary for the notification requests.
  """

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)

  alias NeoscanNode.HttpCalls
  alias NeoscanNode.Parser
  require Logger

  defp get_servers() do
    notification_server = System.get_env("NEO_NOTIFICATIONS_SERVER")

    if is_nil(notification_server) or notification_server == "",
      do: @notification_seeds,
      else: [notification_server]
  end

  defp get_random_server(), do: Enum.random(get_servers())

  defp get_block_notification_page(url, height, page) do
    HttpCalls.get("#{url}/notifications/block/#{height}?page=#{page}")
  end

  defp remaining_pages(total_pages) when total_pages < 2, do: []
  defp remaining_pages(total_pages), do: 2..total_pages

  def get_block_notifications(height) do
    url = get_random_server()

    {:ok, block_notifications, current_height, total_pages} =
      get_block_notification_page(url, height, 1)

    if current_height <= height do
      get_block_notifications(height)
    else
      block_notifications_3 =
        for page <- remaining_pages(total_pages) do
          {:ok, block_notifications_2, _, _} = get_block_notification_page(url, height, page)
          block_notifications_2
        end

      block_notifications = List.flatten(block_notifications_3) ++ block_notifications
      Enum.map(block_notifications, &Parser.parse_block_notification/1)
    end
  end

  def get_token_notifications do
    url = get_random_server()
    {:ok, tokens, _current_height, _total_pages} = HttpCalls.get("#{url}/tokens")
    Enum.map(tokens, &Parser.parse_token/1)
  end

  def get_transfer_block_notifications(height) do
    notifications = get_block_notifications(height)
    Enum.filter(notifications, &(&1.notify_type == :transfer))
  end
end
