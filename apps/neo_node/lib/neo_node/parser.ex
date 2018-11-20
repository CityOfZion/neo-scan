defmodule NeoNode.Parser do
  @address_version "17"

  defp parse16("0x" <> rest), do: parse16(rest)

  defp parse16(string) do
    Base.decode16!(string, case: :mixed)
  end

  # Base.decode64!(string, padding: false)
  defp parse58(string), do: Base58.decode(string)

  defp parse_asset_type("GoverningToken"), do: :governing_token
  defp parse_asset_type("UtilityToken"), do: :utility_token
  defp parse_asset_type("Token"), do: :token
  defp parse_asset_type("Share"), do: :share

  defp parse_transaction_type("PublishTransaction"), do: :publish_transaction
  defp parse_transaction_type("RegisterTransaction"), do: :register_transaction
  defp parse_transaction_type("IssueTransaction"), do: :issue_transaction
  defp parse_transaction_type("MinerTransaction"), do: :miner_transaction
  defp parse_transaction_type("ContractTransaction"), do: :contract_transaction
  defp parse_transaction_type("ClaimTransaction"), do: :claim_transaction
  defp parse_transaction_type("InvocationTransaction"), do: :invocation_transaction
  defp parse_transaction_type("EnrollmentTransaction"), do: :enrollment_transaction
  defp parse_transaction_type("StateTransaction"), do: :state_transaction

  defp parse_decimal(nil), do: nil
  defp parse_decimal(string), do: Decimal.new(string)

  defp parse_claims(nil), do: []
  defp parse_claims(claims), do: Enum.map(claims, &parse_vin/1)

  defp ensure_integer(integer) when is_integer(integer), do: integer

  defp parse_vin(vin) do
    %{
      vout_transaction_hash: parse16(vin["txid"]),
      vout_n: vin["vout"]
    }
  end

  defp parse_vout(vout) do
    %{
      address: parse58(vout["address"]),
      asset: parse16(vout["asset"]),
      n: vout["n"],
      value: parse_decimal(vout["value"])
    }
  end

  defp parse_transaction_asset(nil, _), do: nil

  defp parse_transaction_asset(asset, transaction) do
    asset
    |> Map.merge(%{"id" => transaction["txid"], "issuer" => asset["admin"]})
    |> parse_asset()
  end

  def parse_contract(contract) do
    %{
      author: contract["author"],
      code_version: contract["code_version"],
      email: contract["email"],
      hash: parse16(contract["hash"]),
      name: contract["name"],
      parameters: contract["parameters"],
      properties: contract["properties"],
      return_type: contract["returntype"],
      script: if(is_nil(contract["script"]), do: nil, else: parse16(contract["script"])),
      version: contract["version"]
    }
  end

  def parse_asset(asset) do
    %{
      admin: parse58(asset["admin"]),
      amount: parse_decimal(asset["amount"]),
      available: parse_decimal(asset["available"]),
      expiration: asset["expiration"],
      frozen: asset["frozen"],
      transaction_hash: parse16(asset["id"]),
      issuer: parse58(asset["issuer"]),
      name: parse_asset_name(asset["name"]),
      owner: asset["owner"],
      precision: asset["precision"],
      type: parse_asset_type(asset["type"]),
      version: asset["version"]
    }
  end

  defp parse_asset_name(list) when is_list(list) do
    Enum.reduce(list, %{}, fn %{"lang" => lang, "name" => name}, acc ->
      Map.put(acc, lang, name)
    end)
  end

  def parse_block(block) do
    %{
      confirmations: block["confirmations"],
      hash: parse16(block["hash"]),
      index: block["index"],
      merkle_root: parse16(block["merkleroot"]),
      next_block_hash:
        if(is_nil(block["nextblockhash"]), do: nil, else: parse16(block["nextblockhash"])),
      previous_block_hash: parse16(block["previousblockhash"]),
      next_consensus: parse58(block["nextconsensus"]),
      version: block["version"],
      nonce: parse16(block["nonce"]),
      script: block["script"],
      size: ensure_integer(block["size"]),
      time: DateTime.from_unix!(block["time"]),
      tx: Enum.map(block["tx"], &parse_block_transaction(&1, block))
    }
  end

  defp parse_block_transaction(transaction, block) do
    transaction
    |> Map.merge(%{"blockhash" => block["hash"], "blocktime" => block["time"]})
    |> parse_transaction()
  end

  def parse_transaction(transaction) do
    %{
      asset: parse_transaction_asset(transaction["asset"], transaction),
      nonce: transaction["nonce"],
      extra: %{
        scripts: transaction["scripts"],
        script: transaction["script"],
        contract: transaction["contract"],
        attributes: transaction["attributes"]
      },
      block_time: DateTime.from_unix!(transaction["blocktime"]),
      block_hash: parse16(transaction["blockhash"]),
      size: transaction["size"],
      sys_fee: parse_decimal(transaction["sys_fee"]),
      net_fee: parse_decimal(transaction["net_fee"]),
      hash: parse16(transaction["txid"]),
      type: parse_transaction_type(transaction["type"]),
      version: transaction["version"],
      vins: Enum.map(transaction["vin"], &parse_vin/1),
      vouts: Enum.map(transaction["vout"], &parse_vout/1),
      claims: parse_claims(transaction["claims"])
    }
  end

  def parse_application_log(%{"executions" => executions}) do
    executions
    |> Enum.map(&parse_execution/1)
    |> List.flatten()
    |> Enum.filter(&(not is_nil(&1)))
  end

  defp parse_execution(%{"notifications" => notifications}) do
    Enum.map(notifications, &parse_notification/1)
  end

  defp parse_execution(_), do: nil

  defp parse_notification(%{
         "contract" => contract,
         "state" => %{
           "type" => "Array",
           "value" => [
             %{"type" => "ByteArray", "value" => "7472616e73666572"},
             %{
               "type" => "ByteArray",
               "value" => address_from
             },
             %{
               "type" => "ByteArray",
               "value" => address_to
             },
             %{"type" => "ByteArray", "value" => value}
           ]
         }
       }) do
    %{
      address_from: parse_address(address_from),
      address_to: parse_address(address_to),
      value: parse_integer_value(value),
      contract: parse16(contract)
    }
  end

  defp parse_notification(_), do: nil

  defp parse_integer_value(value) do
    case Base.decode16!(value, case: :mixed) do
      <<x::integer-little-size(56)>> -> x
      <<x::integer-little-size(64)>> -> x
      _ -> 0
    end
  end

  defp parse_address(address) do
    address
    |> (&(@address_version <> &1)).()
    |> Base.decode16!(case: :mixed)
    |> hash256()
    |> Base.encode16()
    |> String.slice(0..7)
    |> (&(@address_version <> address <> &1)).()
    |> Base.decode16!(case: :mixed)
    |> (&if(&1 == <<23, 27, 182, 49, 176>>, do: <<0>>, else: &1)).()
  end

  defp hash256(binary) do
    :crypto.hash(:sha256, :crypto.hash(:sha256, binary))
  end

  # export const getAddressFromScriptHash = (scriptHash: string): string => {
  #   scriptHash = reverseHex(scriptHash);
  #   const shaChecksum = hash256(ADDR_VERSION + scriptHash).substr(0, 8);
  #   return base58.encode(
  #     Buffer.from(ADDR_VERSION + scriptHash + shaChecksum, "hex")
  #   );
  # };

  def parse_version(%{"useragent" => user_agent}) do
    case String.upcase(user_agent) do
      "/NEO:" <> version ->
        {:csharp, version}

      _ ->
        {:python, nil}
    end
  end

  def parse_version(_), do: {:unknown, nil}
end
