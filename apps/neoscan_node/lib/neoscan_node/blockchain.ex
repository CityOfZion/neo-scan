defmodule NeoscanNode.Blockchain do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  alias NeoscanNode.HttpCalls
  alias NeoscanNode.NodeChecker

  defp parse16("0x" <> rest), do: parse16(rest)

  defp parse16(string) do
    string
    |> String.upcase()
    |> Base.decode16!()
  end

  defp parse64(string), do: Base.decode64!(string, padding: false)

  defp parse_transaction_type("RegisterTransaction"), do: :register_transaction
  defp parse_transaction_type("IssueTransaction"), do: :issue_transaction
  defp parse_transaction_type("MinerTransaction"), do: :miner_transaction
  defp parse_transaction_type("ContractTransaction"), do: :contract_transaction
  defp parse_transaction_type("ClaimTransaction"), do: :claim_transaction
  defp parse_transaction_type("InvocationTransaction"), do: :invocation_transaction

  defp parse_float(string), do: elem(Float.parse(string), 0)

  defp parse_vin(vin) do
    %{
      transaction_hash: parse16(vin["txid"]),
      vout_index: vin["vout"]
    }
  end

  defp parse_vout(vout) do
    %{
      address: parse64(vout["address"]),
      asset: parse16(vout["asset"]),
      n: vout["n"],
      value: parse_float(vout["value"])
    }
  end

  defp parse_block_transaction(transaction) do
    %{
      attributes: transaction["attributes"],
      net_fee: transaction["net_fee"],
      nonce: transaction["nonce"],
      scripts: transaction["scripts"],
      size: transaction["size"],
      sys_fee: transaction["sys_fee"],
      hash: parse16(transaction["txid"]),
      type: parse_transaction_type(transaction["type"]),
      version: transaction["version"],
      vin: Enum.map(transaction["vin"], &parse_vin/1),
      vout: Enum.map(transaction["vout"], &parse_vout/1)
    }
  end

  defp parse_block(block) do
    %{
      confirmations: block["confirmations"],
      hash: parse16(block["hash"]),
      index: block["index"],
      merkle_root: parse16(block["merkleroot"]),
      next_block_hash: parse16(block["nextblockhash"]),
      previous_block_hash: parse16(block["previousblockhash"]),
      next_consensus: parse64(block["nextconsensus"]),
      nonce: parse16(block["nonce"]),
      script: block["script"],
      size: block["size"],
      time: DateTime.from_unix!(block["time"]),
      tx: Enum.map(block["tx"], &parse_block_transaction/1)
    }
  end

  defp parse_transaction(transaction) do
    hash = transaction["blockhash"]

    transaction
    |> Map.put("blockhash", parse16(hash))
    |> Map.put("hash", parse16(transaction["txid"]))
    |> Map.delete("txid")
  end

  @doc """
   Get the current block by height through seed 'index'
  """
  def get_block_by_height(height), do: get_block_by_height(NodeChecker.get_random_node(), height)

  def get_block_by_height(url, height) do
    {:ok, response} = HttpCalls.post(url, "getblock", [height, 1])
    {:ok, parse_block(response)}
  end

  def get_block_by_hash(hash), do: get_block_by_hash(NodeChecker.get_random_node(), hash)

  def get_block_by_hash(url, hash) do
    {:ok, response} = HttpCalls.post(url, "getblock", [hash, 1])
    {:ok, parse_block(response)}
  end

  def get_current_height, do: get_current_height(NodeChecker.get_random_node())

  def get_current_height(url), do: HttpCalls.post(url, "getblockcount", [])

  def get_transaction(txid), do: get_transaction(NodeChecker.get_random_node(), txid)

  def get_transaction(url, txid) do
    {:ok, response} = HttpCalls.post(url, "getrawtransaction", [txid, 1])
    {:ok, parse_transaction(response)}
  end

  def get_asset(txid), do: get_asset(NodeChecker.get_random_node(), txid)

  def get_asset(url, txid), do: HttpCalls.post(url, "getassetstate", [txid, 1])

  def get_contract(hash), do: get_contract(NodeChecker.get_random_node(), hash)

  def get_contract(url, hash), do: HttpCalls.post(url, "getcontractstate", [hash])
end
