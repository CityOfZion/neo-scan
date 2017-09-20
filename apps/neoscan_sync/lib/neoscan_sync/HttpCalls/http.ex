defmodule NeoscanSync.HttpCalls do
  @moduledoc false

  require Logger

  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(1)
    "http://seed2.antshares.org:10332"

  """
  def url(n) do
    NeoscanMonitor.Api.get_nodes
    |> test_if_nodes(n)
  end

  defp test_if_nodes(list, n) do
    cond do
      Enum.count(list) > n ->
        Enum.take_random(list, n)
      true ->
        list
    end
  end

  #Makes a request to the 'url' seed
  def request(headers, data, url) do
    url
    |> HTTPoison.post( data, headers, ssl: [{:versions, [:'tlsv1.2']}] )
    |> handle_response
  end

  #Handles the response of an HTTP call
  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode!(body)
    |> handle_body
  end
  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    Logger.error "Error 404 Not found! :("
    { :error , "Error 404 Not found! :(" }
  end
  defp handle_response({:ok, %HTTPoison.Response{status_code: 405}}) do
    Logger.error "Error 405 Method not found! :("
    { :error , "Error 405 Method not found! :(" }
  end
  defp handle_response({:ok, %HTTPoison.Response{}}) do
    Logger.error "Web server error! :("
    { :error , "Web server error! :(" }
  end
  defp handle_response({:error, %HTTPoison.Error{reason: :timeout}}) do
    Logger.error "timeout, retrying....."
    { :error , :timeout}
  end
  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error reason
    { :error , "urlopen error, retry."}
  end

  #handles a sucessful response
  defp handle_body(%{"result" => result}) do
    {:ok, result }
  end
  defp handle_body(%{"error" => error}) do
    {:error, error}
  end
  defp handle_body(_body) do
    {:error,"server error"}
  end


end
