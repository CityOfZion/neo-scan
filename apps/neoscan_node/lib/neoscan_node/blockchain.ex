defmodule NeoscanNode.Blockchain do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanNode.HttpCalls
  alias NeoscanNode.NodeChecker
  alias NeoscanNode.Parser

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(height), do: get_block_by_height(NodeChecker.get_random_node(), height)

  def get_block_by_height(url, height) do
    {:ok, response} = HttpCalls.post(url, "getblock", [height, 1])
    {:ok, Parser.parse_block(response)}
  end

  def get_block_by_hash(hash), do: get_block_by_hash(NodeChecker.get_random_node(), hash)

  def get_block_by_hash(url, hash) do
    {:ok, response} = HttpCalls.post(url, "getblock", [hash, 1])
    {:ok, Parser.parse_block(response)}
  end

  def get_current_height, do: get_current_height(NodeChecker.get_random_node())

  def get_current_height(url), do: HttpCalls.post(url, "getblockcount", [])

  def get_transaction(txid), do: get_transaction(NodeChecker.get_random_node(), txid)

  def get_transaction(url, txid) do
    {:ok, response} = HttpCalls.post(url, "getrawtransaction", [txid, 1])
    {:ok, Parser.parse_transaction(response)}
  end

  def get_asset(txid), do: get_asset(NodeChecker.get_random_node(), txid)

  def get_asset(url, txid) do
    {:ok, response} = HttpCalls.post(url, "getassetstate", [txid, 1])
    {:ok, Parser.parse_asset(response)}
  end

  def get_contract(hash), do: get_contract(NodeChecker.get_random_node(), hash)

  def get_contract(url, hash) do
    {:ok, response} = HttpCalls.post(url, "getcontractstate", [hash])
    {:ok, Parser.parse_contract(response)}
  end
end
