defmodule NeoscanSync.Notifications do
  use HTTPoison.Base

  @moduledoc """
  The boundary for the notification requests.
  """

  alias NeoscanSync.HttpCalls
  require Logger

  def get_block_notifications(height) do
    "#{get_url()}/notifications/block/#{height}"
    |> HttpCalls.get()
    |> check(height)
  end

  def get_token_notifications do
    "#{get_url()}/tokens"
    |> HttpCalls.get()
    |> check_token()
  end

  def get_url() do
    Application.fetch_env!(:neoscan_sync, :notification_seeds)
    |> Enum.random()
  end

  defp check_token({:ok, result, _current_height}) do
    result
  end
  defp check_token(_response) do
    Logger.info("error getting notifications for tokens")
    {:error, "error getting notifications"}
  end

  defp check({:ok, result, current_height}, height) do
    cond do
      current_height-1 < height ->
        get_block_notifications(height)
      current_height-1 >= height ->
        result
    end
  end
  defp check(_response, height) do
    Logger.info("error getting notifications for block #{height}")
    {:error, "error getting notifications"}
  end

end
