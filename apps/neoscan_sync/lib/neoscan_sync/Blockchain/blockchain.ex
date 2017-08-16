defmodule NeoscanSync.Blockchain do
  use HTTPoison.Base

  @moduledoc false
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanSync.HttpCalls

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(url , height ) do
    data = Poison.encode!(%{
      "jsonrpc" => "2.0",
       "method" => "getblock",
       "params" => [ height, 1 ],
       "id" => 5
    })
    headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, url)
  end

  def get_current_height(url) do
    data = Poison.encode!(%{
      "jsonrpc": "2.0",
       "method": "getblockcount",
       "params": [],
       "id": 5
    })
  	headers = [{"Content-Type", "application/json"}]
    HttpCalls.request(headers, data, url)
  end

end
