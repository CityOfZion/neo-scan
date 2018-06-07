defmodule NeoscanNode.Notifications do
  @moduledoc """
  The boundary for the notification requests.
  """

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)
  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  alias NeoscanNode.HttpCalls
  require Logger

  defp get_servers() do
    notification_server = System.get_env("NEO_NOTIFICATIONS_SERVER")
    if is_nil(notification_server), do: @notification_seeds, else: [notification_server]
  end

  defp get_random_server(), do: Enum.random(get_servers())

  def get_block_notifications(height) do
    url = get_random_server()
    {:ok, result, _} = HttpCalls.get("#{url}/notifications/block/#{height}")
    result
  end

  def get_token_notifications do
    url = get_random_server()
    {:ok, result, _current_height} = HttpCalls.get("#{url}/tokens")

    result
  end

  def get_transfer_notification(height) when height <= @limit_height, do: []

  def get_transfer_notification(height) do
    notifications = get_block_notifications(height)
    Enum.filter(notifications, &(&1["notify_type"] == "transfer"))
  end

  def add_notifications(block, height) do
    Map.merge(block, %{"transfers" => get_transfer_notification(height)})
  end
end
