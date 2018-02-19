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
    |> check()
  end

  defp check({:ok, result}) do
    result
  end
  defp check(_response) do
    Logger.info("error getting notifications for tokens")
    {:error, "error getting notifications"}
  end
  defp check({:ok, result}, _height) do
    result
  end
  defp check(_response, height) do
    Logger.info("error getting notifications for block #{height}")
    {:error, "error getting notifications"}
  end
  
end
