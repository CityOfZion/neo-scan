defmodule NeoscanNode.Blockchain do
  use HTTPoison.Base

  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanNode.HttpCalls

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(url, height) do
    data =
      Poison.encode!(%{
        "jsonrpc" => "2.0",
        "method" => "getblock",
        "params" => [height, 1],
        "id" => 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  def get_block_by_hash(url, hash) do
    data =
      Poison.encode!(%{
        "jsonrpc" => "2.0",
        "method" => "getblock",
        "params" => [hash, 1],
        "id" => 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  def get_current_height(url) do
    data =
      Poison.encode!(%{
        jsonrpc: "2.0",
        method: "getblockcount",
        params: [],
        id: 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  def get_transaction(url, txid) do
    data =
      Poison.encode!(%{
        jsonrpc: "2.0",
        method: "getrawtransaction",
        params: [txid, 1],
        id: 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  def get_asset(url, txid) do
    data =
      Poison.encode!(%{
        jsonrpc: "2.0",
        method: "getassetstate",
        params: [txid, 1],
        id: 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end

  def get_contract(url, hash) do
    data =
      Poison.encode!(%{
        jsonrpc: "2.0",
        method: "getcontractstate",
        params: [hash],
        id: 5
      })

    headers = [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]
    HttpCalls.request(headers, data, url)
  end
end
