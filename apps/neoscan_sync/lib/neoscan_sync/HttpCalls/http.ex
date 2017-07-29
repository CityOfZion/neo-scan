defmodule NeoscanSync.HttpCalls do
  @moduledoc false

  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(1)
    "http://seed2.antshares.org:10332"

  """
  def url(index \\ 0) do
    %{
      0 => "http://seed1.cityofzion.io:8080",
      1 => "http://seed1.cityofzion.io:8080",
      2 => "http://seed2.cityofzion.io:8080",
      3 => "http://seed2.cityofzion.io:8080",
      4 => "http://seed3.cityofzion.io:8080",
      5 => "http://seed3.cityofzion.io:8080",
      6 => "http://seed4.cityofzion.io:8080",
      7 => "http://seed4.cityofzion.io:8080",
      8 => "http://seed5.cityofzion.io:8080",
      9 => "http://seed5.cityofzion.io:8080",
    }
    |> Map.get(index)
  end

  #Makes a request to the 'index' seed
  def request(headers, data, index) do
    url(index)
    |> HTTPoison.post( data, headers, ssl: [{:versions, [:'tlsv1.2']}] )
    |> handle_response
  end

  #Handles the response of an HTTP call
  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"result" => result} = Poison.decode!(body)
        {:ok, result }
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
