defmodule NeoscanNode.HttpCalls do
  @moduledoc false

  require Logger

  @doc """
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(1)
    "http://seed2.antshares.org:10332"

  """
  alias NeoscanNode.Worker
  alias NeoscanNode.HttpCalls.HTTPPoisonWrapper

  def get_url(n) do
    nodes = Worker.get_nodes()

    if Enum.count(nodes) > n do
      Enum.take_random(nodes, n)
    else
      nodes
    end
  end

  # Makes a request to the 'url' seed
  def request(headers, data, url) when is_bitstring(url) do
    HTTPPoisonWrapper.post(url, data, headers, ssl: [{:versions, [:"tlsv1.2"]}])
    |> handle_response(url)
  end

  def request(headers, data, [url]) when is_bitstring(url), do: request(headers, data, url)
  def request(_, _, url), do: Logger.error("Error in url #{inspect(url)}")

  # Makes a request to the 'url' seed
  def get(url) when is_bitstring(url) do
    HTTPPoisonWrapper.get(url, [], ssl: [{:versions, [:"tlsv1.2"]}])
    |> handle_response(url)
  end

  def get([url]) when is_bitstring(url), do: get(url)
  def get(url), do: Logger.error("Error in url #{inspect(url)}")

  # Handles the response of an HTTP call
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body} = res}, _) do
    gzipped =
      {"Content-Encoding", "gzip"} in res.headers or {"Content-Encoding", "x-gzip"} in res.headers

    # body is an Elixir string
    body = if gzipped, do: :zlib.gunzip(body), else: body

    body
    |> Poison.decode()
    |> handle_body
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
