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

  defp check({:ok, result}, _height) do
    result
  end
  defp check(_response, height) do
    Logger.info("error getting notifications for block #{height}")
    {:error, "error getting notifications"}
  end

end
