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
    case HttpCalls.post(url, "getblock", [height, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_block_by_hash(hash), do: get_block_by_hash(NodeChecker.get_random_node(), hash)

  def get_block_by_hash(url, hash) do
    case HttpCalls.post(url, "getblock", [hash, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_block_count, do: get_block_count(NodeChecker.get_random_node())

  def get_block_count(url), do: HttpCalls.post(url, "getblockcount", [])

  def get_transaction(txid), do: get_transaction(NodeChecker.get_random_node(), txid)

  def get_transaction(url, txid) do
    case HttpCalls.post(url, "getrawtransaction", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_transaction(response)}

      error ->
        error
    end
  end

  def get_asset(txid), do: get_asset(NodeChecker.get_random_node(), txid)

  def get_asset(url, txid) do
    case HttpCalls.post(url, "getassetstate", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_asset(response)}

      error ->
        error
    end
  end

  def get_contract(hash), do: get_contract(NodeChecker.get_random_node(), hash)

  def get_contract(url, hash) do
    case HttpCalls.post(url, "getcontractstate", [hash]) do
      {:ok, response} ->
        {:ok, Parser.parse_contract(response)}

      error ->
        error
    end
  end
end
