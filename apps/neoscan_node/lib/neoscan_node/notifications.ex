defmodule NeoscanNode.Notifications do
  @moduledoc """
  The boundary for the notification requests.
  """

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)
  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  alias NeoscanNode.HttpCalls
  alias NeoscanNode.Parser
  require Logger

  defp get_servers() do
    notification_server = System.get_env("NEO_NOTIFICATIONS_SERVER")
    if is_nil(notification_server), do: @notification_seeds, else: [notification_server]
  end

  defp get_random_server(), do: Enum.random(get_servers())

  def get_block_notifications(height) do
    url = get_random_server()
    {:ok, block_notifications, _} = HttpCalls.get("#{url}/notifications/block/#{height}")
    Enum.map(block_notifications, &Parser.parse_block_notification/1)
  end

  def get_token_notifications do
    url = get_random_server()
    {:ok, tokens, _current_height} = HttpCalls.get("#{url}/tokens")
    Enum.map(tokens, &Parser.parse_token/1)
  end

  def get_transfer_block_notifications(height) when height <= @limit_height, do: []

  def get_transfer_block_notifications(height) do
    notifications = get_block_notifications(height)
    Enum.filter(notifications, &(&1.notify_type == :transfer))
  end
end
