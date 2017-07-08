defmodule Neoscan.Blockchain do
  use HTTPoison.Base
  @moduledoc """
  The boundary for the Blockchain requests.
  """


  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(0)
    "http://seed1.antshares.org:10332"

  """
  def url(index \\ 0) do
    %{
      0 => "http://seed1.antshares.org:10332",
      1 => "http://seed2.antshares.org:10332",
      2 => "http://seed3.antshares.org:10332",
      3 => "http://seed4.antshares.org:10332",
      4 => "http://seed5.antshares.org:10332",
    }
    |> Map.get(index)
  end

  @doc """
   Makes a request to the 'index' seed
  """
  def request(headers, data, index) do
    url(index)
    |> HTTPoison.post( data, headers )
  end

  @doc """
   Get the current block height from the Blockchain through seed 'index'
  """
  def get_current_height(conn, %{:index => index }) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblockcount",
       "params" => [0],
       "id" => 5
    })
  	headers = %{"Content-Type" => "application/json"}
    case request(headers, data, index) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {conn, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "GetCurrentHeight() Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "GetCurrentHeight() urlopen error, retry."
        IO.inspect reason
        reason
    end



  end

end
