defmodule NeoscanSync.Notifications do
  use HTTPoison.Base

  @moduledoc """
  The boundary for the notification requests.
  """

  alias NeoscanSync.HttpCalls
  require Logger

  def get_block_notifications(height) do
    "http://notifications.neeeo.org/block/#{height}"
    |> HttpCalls.get()
    |> check(height)
  end

  def get_token_notifications do
    "http://notifications.neeeo.org/tokens"
    |> HttpCalls.get()
    |> check_token()
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
      current_height < height ->
        get_block_notifications(height)
      current_height >= height ->
        result
    end
  end
  defp check(_response, height) do
    Logger.info("error getting notifications for block #{height}")
    {:error, "error getting notifications"}
  end

end
