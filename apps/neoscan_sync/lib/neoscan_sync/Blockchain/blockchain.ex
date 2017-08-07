defmodule NeoscanSync.Blockchain do
  use HTTPoison.Base

  @moduledoc false
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanSync.HttpCalls

  @doc """
   Get the current block height from the Blockchain through seed 'index'
  """
  def get_current_height() do
    height = Enum.to_list(0..9)
    |> Enum.map(&Task.async( fn -> get_height(&1) end))
    |> Enum.map(&Task.await(&1, 20000))
    |> Enum.map(fn x -> case x do
      {:ok, x} -> x
      {:error, _reason} -> nil
    end
    end)
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.min()

    { :ok, height}
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(index , height ) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblock",
       "params" => [ height, 1 ],
       "id" => 5
    })
    headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, index)
  end

  def get_height(index) do
    data = Poison.encode!(%{
      "jsonrpc": "2.0",
       "method": "getblockcount",
       "params": [],
       "id": 5
    })
  	headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, index)
  end

end
