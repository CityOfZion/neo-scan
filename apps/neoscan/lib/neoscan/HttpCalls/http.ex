defmodule Neoscan.HttpCalls do

  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(1)
    "http://seed2.antshares.org:10332"

  """
  def url(index \\ 0) do
    %{
      0 => "https://localhost:20332",
      1 => "http://seed2.antshares.org:10332",
      2 => "http://seed3.antshares.org:10332",
      3 => "http://seed4.antshares.org:10332",
      4 => "http://seed5.antshares.org:10332",
    }
    # %{
    #   0 => "http://seed1.antshares.org:10332",
    #   1 => "http://seed2.antshares.org:10332",
    #   2 => "http://seed3.antshares.org:10332",
    #   3 => "http://seed4.antshares.org:10332",
    #   4 => "http://seed5.antshares.org:10332",
    # }
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
        IO.puts "404 Not found :("
        { :ok, nil }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "urlopen error, retry."
        IO.inspect reason
        { :error, nil }
    end
  end

end
