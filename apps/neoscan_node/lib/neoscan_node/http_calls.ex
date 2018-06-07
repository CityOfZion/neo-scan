defmodule NeoscanNode.HttpCalls do
  @moduledoc false

  require Logger

  alias NeoscanNode.HttpCalls.HTTPPoisonWrapper

  @opts [ssl: [{:versions, [:"tlsv1.2"]}]]

  def request(headers, data, url) when is_bitstring(url) do
    result = HTTPPoisonWrapper.post(url, data, headers, @opts)
    handle_response(result, url)
  end

  def request(_, _, url), do: Logger.error("Error in url #{inspect(url)}")

  def get(url) when is_bitstring(url) do
    result = HTTPPoisonWrapper.get(url, [], @opts)
    handle_response(result, url)
  end

  def get(url), do: Logger.error("Error in url #{inspect(url)}")

  # Handles the response of an HTTP call
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body} = res}, _) do
    gzipped =
      {"Content-Encoding", "gzip"} in res.headers or {"Content-Encoding", "x-gzip"} in res.headers

    # body is an Elixir string
    body = if gzipped, do: :zlib.gunzip(body), else: body

    body
    |> Poison.decode()
    |> handle_body()
  end

  defp handle_response({_, result}, url) do
    message = "#{inspect(result)} #{url}"
    Logger.warn(message)
    {:error, message}
  end

  # handles a sucessful response
  defp handle_body({:ok, %{"result" => result}}), do: {:ok, result}

  defp handle_body({:ok, %{"results" => result, "current_height" => current_height}}),
    do: {:ok, result, current_height}

  defp handle_body({:ok, %{"results" => results}}), do: {:ok, results}
  defp handle_body({:ok, %{"error" => error}}), do: {:error, error}
  defp handle_body(error), do: {:error, "body error: #{inspect(error)}"}
end
