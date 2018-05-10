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

  def get_url(n) do
    url(Worker.get_nodes(), n)
  end

  def url(nodes, n \\ 1) do
    test_if_nodes(nodes, n)
  end

  defp test_if_nodes(list, n) do
    if Enum.count(list) > n do
      Enum.take_random(list, n)
    else
      list
    end
  end

  # Makes a request to the 'url' seed
  def request(headers, data, url) do
    try do
      to_string(url)
    rescue
      ArgumentError ->
        Logger.error("Error in url #{url}")
    else
      value ->
        value
        |> HTTPoison.post(data, headers, ssl: [{:versions, [:"tlsv1.2"]}])
        |> handle_response
    end
  end

  # Makes a request to the 'url' seed
  def get(url) do
    try do
      to_string(url)
    rescue
      ArgumentError ->
        Logger.error("Error in url #{url}")
    else
      value ->
        value
        |> HTTPoison.get([], ssl: [{:versions, [:"tlsv1.2"]}])
        |> handle_response
    end
  end

  # Handles the response of an HTTP call
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body} = res}) do
    gzipped =
      Enum.any?(res.headers, fn kv ->
        case kv do
          {"Content-Encoding", "gzip"} -> true
          {"Content-Encoding", "x-gzip"} -> true
          _ -> false
        end
      end)

    # body is an Elixir string
    body =
      if gzipped do
        :zlib.gunzip(body)
      else
        body
      end

    Poison.decode!(body)
    |> handle_body
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    Logger.error("Error 404 Not found! :(")
    {:error, "Error 404 Not found! :("}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 405}}) do
    Logger.error("Error 405 Method not found! :(")
    {:error, "Error 405 Method not found! :("}
  end

  defp handle_response({:ok, %HTTPoison.Response{}}) do
    Logger.error("Web server error! :(")
    {:error, "Web server error! :("}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: :timeout}}) do
    Logger.warn("timeout, retrying.....")
    {:error, :timeout}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.warn(reason)
    {:error, "urlopen error, retry."}
  end

  # handles a sucessful response
  defp handle_body(%{"result" => result}) do
    {:ok, result}
  end

  defp handle_body(%{"results" => result, "current_height" => current_height}) do
    {:ok, result, current_height}
  end

  defp handle_body(%{"results" => result}) do
    {:ok, result}
  end

  defp handle_body(%{"error" => error}) do
    {:error, error}
  end

  defp handle_body(_body) do
    {:error, "server error"}
  end
end
