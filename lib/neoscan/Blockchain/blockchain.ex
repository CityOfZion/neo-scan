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

  @doc """
   Makes a request to the 'index' seed
  """
  defp request(headers, data, index) do
    url(index)
    |> HTTPoison.post( data, headers, ssl: [{:versions, [:'tlsv1.2']}] )
  end

  @doc """
   Handles the response of an HTTP call
  """
  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"result" => result} = Poison.decode!(body)
        result
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "404 Not found :("
        ""
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "urlopen error, retry."
        IO.inspect reason
        ""
    end
  end


  @doc """
   Add the connection param back into response
  """
  defp add_conn( params, conn) do
    {conn, params }
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
    |> handle_response()
    |> add_conn( conn )
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
    |> handle_response()
    |> add_conn( conn )
  end

end
