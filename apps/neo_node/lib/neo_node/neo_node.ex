defmodule NeoNode do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoNode.HttpCalls
  alias NeoNode.Parser

  @doc """
   Get the current block by height through seed 'index'
  """

  def get_block_by_height(url, height) do
    case HttpCalls.post(url, "getblock", [height, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_block_by_hash(url, hash) do
    case HttpCalls.post(url, "getblock", [hash, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_block_count(url), do: HttpCalls.post(url, "getblockcount", [])

  def get_transaction(url, txid) do
    case HttpCalls.post(url, "getrawtransaction", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_transaction(response)}

      error ->
        error
    end
  end

  def get_asset(url, txid) do
    case HttpCalls.post(url, "getassetstate", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_asset(response)}

      error ->
        error
    end
  end

  def get_contract(url, hash) do
    case HttpCalls.post(url, "getcontractstate", [hash]) do
      {:ok, response} ->
        {:ok, Parser.parse_contract(response)}

      error ->
        error
    end
  end
end
