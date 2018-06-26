defmodule NeoscanNode.HttpCalls do
  @moduledoc false

  require Logger

  alias NeoscanNode.HttpCalls.HTTPPoisonWrapper

  @timeout 5_000

  @opts [ssl: [{:versions, [:"tlsv1.2"]}], timeout: @timeout, recv_timeout: @timeout]
  @headers [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]

  def post(url, method, params) when is_bitstring(url) do
    data =
      Poison.encode!(%{
        "jsonrpc" => "2.0",
        "method" => method,
        "params" => params,
        "id" => 5
      })

    result = HTTPPoisonWrapper.post(url, data, @headers, @opts)
    handle_response(result, url)
  end

  def get(url) when is_bitstring(url) do
    result = HTTPPoisonWrapper.get(url, [], @opts)
    handle_response(result, url)
  end

  # Handles the response of an HTTP call
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body} = res}, _) do
    gzipped =
      {"Content-Encoding", "gzip"} in res.headers or {"Content-Encoding", "x-gzip"} in res.headers

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

  defp handle_body(
         {:ok,
          %{"results" => result, "current_height" => current_height, "total_pages" => total_pages}}
       ),
       do: {:ok, result, current_height, total_pages}

  defp handle_body({:ok, %{"results" => results}}), do: {:ok, results}
  defp handle_body({:ok, %{"error" => error}}), do: {:error, error}
  defp handle_body(error), do: {:error, "body error: #{inspect(error)}"}
end
