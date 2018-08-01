defmodule NeoNotification do
  @moduledoc """
  The boundary for the notification requests.
  """

  alias NeoNotification.HTTPPoisonWrapper
  alias NeoNotification.Parser
  require Logger

  @timeout 2_000
  @opts [ssl: [{:versions, [:"tlsv1.2"]}], timeout: @timeout, recv_timeout: @timeout]
  #
  def get_block_transfers(url, height) do
    case get_block_notifications(url, height) do
      {:ok, notifications} ->
        {:ok, Enum.filter(notifications, &(&1.notify_type == :transfer))}

      error ->
        error
    end
  end

  def get_current_height(url) do
    case get_block_notifications_page(url, 0, 1) do
      {:ok, _, current_height, _} ->
        {:ok, current_height}

      _ ->
        {:error, :error}
    end
  end

  def get_block_notifications(url, height), do: get_block_notifications(url, height, 1, nil, [])

  defp get_block_notifications(_, _, page, total_pages, acc)
       when total_pages == 0 or page > total_pages,
       do: {:ok, acc}

  defp get_block_notifications(url, height, page, _, acc) do
    case get_block_notifications_page(url, height, page) do
      {:ok, block_notifications, current_height, total_pages} when current_height >= height ->
        parsed_block_notifications =
          Enum.map(block_notifications, &Parser.parse_block_notification/1)

        get_block_notifications(
          url,
          height,
          page + 1,
          total_pages,
          parsed_block_notifications ++ acc
        )

      _ ->
        {:error, :error}
    end
  end

  def get_tokens(url), do: get_tokens(url, 1, nil, [])

  defp get_tokens(_, page, total_pages, acc) when total_pages == 0 or page > total_pages,
    do: {:ok, acc}

  defp get_tokens(url, page, _, acc) do
    case get_tokens_page(url, page) do
      {:ok, tokens, _, total_pages} ->
        parsed_tokens = Enum.map(tokens, &Parser.parse_token/1)
        get_tokens(url, page + 1, total_pages, parsed_tokens ++ acc)

      _ ->
        {:error, :error}
    end
  end

  defp get_block_notifications_page(url, height, page) do
    get("#{url}/notifications/block/#{height}?page=#{page}")
  end

  defp get_tokens_page(url, page) do
    get("#{url}/tokens?page=#{page}")
  end

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
