defmodule NeoNotification do
  @moduledoc """
  The boundary for the notification requests.
  """

  alias NeoNotification.HTTPPoisonWrapper
  alias NeoNotification.Parser
  require Logger

  @timeout 5_000
  @opts [ssl: [{:versions, [:"tlsv1.2"]}], timeout: @timeout, recv_timeout: @timeout]

  def get_block_transfers(url, height) do
    notifications = get_block_notifications(url, height)
    Enum.filter(notifications, &(&1.notify_type == :transfer))
  end

  def get_current_height(url) do
    case get_block_notifications_page(url, 0, 1) do
      {:ok, _, current_height, _} ->
        current_height

      _ ->
        nil
    end
  end

  def get_block_notifications(url, height) do
    {:ok, block_notifications, current_height, total_pages} =
      get_block_notifications_page(url, height, 1)

    if current_height <= height do
      {:error, :notification_server_lagging}
    else
      block_notifications_3 =
        for page <- remaining_pages(total_pages) do
          {:ok, block_notifications_2, _, _} = get_block_notifications_page(url, height, page)
          block_notifications_2
        end

      block_notifications = List.flatten(block_notifications_3) ++ block_notifications
      Enum.map(block_notifications, &Parser.parse_block_notification/1)
    end
  end

  def get_tokens(url) do
    {:ok, tokens, _current_height, total_pages} = get_tokens_page(url, 1)

    tokens_3 =
      for page <- remaining_pages(total_pages) do
        {:ok, tokens_2, _, _} = get_tokens_page(url, page)
        tokens_2
      end

    tokens = List.flatten(tokens_3) ++ tokens
    Enum.map(tokens, &Parser.parse_token/1)
  end

  defp get_block_notifications_page(url, height, page) do
    get("#{url}/notifications/block/#{height}?page=#{page}")
  end

  defp get_tokens_page(url, page) do
    get("#{url}/tokens?page=#{page}")
  end

  defp remaining_pages(total_pages) when total_pages < 2, do: []
  defp remaining_pages(total_pages), do: 2..total_pages

  def get(url) do
    case HTTPPoisonWrapper.get(url, [], @opts) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode()
        |> handle_body()

      {_, result} ->
        message = "#{inspect(result)} #{url}"
        Logger.debug(message)
        {:error, message}
    end
  end

  # handles a sucessful response}
  defp handle_body({
         :ok,
         %{"results" => result, "current_height" => current_height, "total_pages" => total_pages}
       }),
       do: {:ok, result, current_height, total_pages}

  defp handle_body({:ok, %{"error" => error}}), do: {:error, error}
  defp handle_body(error), do: {:error, "body error: #{inspect(error)}"}
end
