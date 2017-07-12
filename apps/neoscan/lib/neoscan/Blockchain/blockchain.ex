defmodule Neoscan.Blockchain do
  use HTTPoison.Base
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias Neoscan.HttpCalls

  @doc """
   Get the current block height from the Blockchain through seed 'index'
  """
  def get_current_height(%{:index => index }) do
    data = Poison.encode!(%{
      "jsonrpc": "2.0",
       "method": "getblockcount",
       "params": [],
       "id": 5
    })
  	headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, index)
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(%{:index => index , :height => height }) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblock",
       "params" => [ height, 1 ],
       "id" => 5
    })
    headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, index)
  end

end
