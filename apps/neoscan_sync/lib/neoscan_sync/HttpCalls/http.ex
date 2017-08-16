defmodule NeoscanSync.HttpCalls do
  @moduledoc false

  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(1)
    "http://seed2.antshares.org:10332"

  """
  def url(n) do
    NeoscanMonitor.Api.get_nodes
    |> Enum.take_random(n)
  end

  #Makes a request to the 'index' seed
  def request(headers, data, url) do
    url
    |> HTTPoison.post( data, headers, ssl: [{:versions, [:'tlsv1.2']}] )
    |> handle_response
  end

  #Handles the response of an HTTP call
  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
          %{"result" => result} ->
            {:ok, result }
          %{"error" => error} ->
            NeoscanMonitor.Api.error
            {:error, error}

          _ ->
            NeoscanMonitor.Api.error
            {:error,"server error"}
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Error 404 Not found! :("
        { :error , "Error 404 Not found! :(" }
      {:ok, %HTTPoison.Response{status_code: 405}} ->
        IO.puts "Error 405 Method not found! :("
        { :error , "Error 405 Method not found! :(" }
      {:error, %HTTPoison.Error{reason: :timeout}} ->
        IO.puts "timeout, retrying....."
        { :error , :timeout}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "urlopen error, retry."
        IO.inspect reason
        { :error , "urlopen error, retry."}
    end
  end

end
