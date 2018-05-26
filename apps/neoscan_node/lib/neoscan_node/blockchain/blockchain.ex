defmodule NeoscanNode.Blockchain do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanNode.HttpCalls

  defp request(url, method, params) do
    data =
      Poison.encode!(%{"jsonrpc" => "2.0", "method" => method, "params" => params, "id" => 5})

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(url, height), do: request(url, "getblock", [height, 1])

  def get_block_by_hash(url, hash), do: request(url, "getblock", [hash, 1])

  def get_current_height(url), do: request(url, "getblockcount", [])

  def get_transaction(url, txid), do: request(url, "getrawtransaction", [txid, 1])

  def get_asset(url, txid), do: request(url, "getassetstate", [txid, 1])

  def get_contract(url, hash), do: request(url, "getcontractstate", [hash])
end
