defmodule Neoscan.Blockchain do
  use HTTPoison.Base
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias Neoscan.Blocks
  alias Neoscan.Transactions


  @doc ~S"""
   Returns seed url according with 'index'

  ## Examples

    iex> Neoscan.Blockchain.url(0)
    "http://seed1.antshares.org:10332"

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

  @doc """
   Makes a request to the 'index' seed
  """
  def request(headers, data, index) do
    url(index)
    |> HTTPoison.post( data, headers )
  end

  @doc """
   Handles the response of an HTTP call
  """
  def handle_response(response, conn) do
    IO.inspect(response)
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {conn, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "404 Not found :("
        {conn , ""}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "urlopen error, retry."
        IO.inspect reason
        {conn , ""}
    end
  end

  @doc """
   Get the current block height from the Blockchain through seed 'index'
  """
  def get_current_height(conn, %{:index => index }) do
    data = Poison.encode!(%{
      "jsonrpc": "2.0",
       "method": "getblockcount",
       "params": [],
       "id": 5
    })
  	headers = [{"Content-Type", "application/json"}]
    request(headers, data, index)
    |> handle_response(conn)
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(conn, %{:index => index , :height => height }) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblock",
       "params" => [ height, 1 ],
       "id" => 5
    })
    headers = %{"Content-Type" => "application/json"}
    request(headers, data, index)
    |> handle_response(conn)
  end

end
