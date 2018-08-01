defmodule NeoNotification.Parser do
  defp parse16("0x" <> rest), do: parse16(rest)
  defp parse16(string), do: Base.decode16!(string, case: :mixed)

  defp parse58(string), do: Base58.decode(string)

  defp parse_integer(string), do: String.to_integer(string)

  defp parse_notify_type("transfer"), do: :transfer

  def parse_block_notification(block_notification = %{"notify_type" => "transfer"}) do
    %{
      addr_from: parse58(block_notification["addr_from"]),
      addr_to: parse58(block_notification["addr_to"]),
      amount: parse_integer(block_notification["amount"]),
      block: block_notification["block"],
      contract: parse16(block_notification["contract"]),
      notify_type: parse_notify_type(block_notification["notify_type"]),
      transaction_hash: parse16(block_notification["tx"]),
      type: block_notification["type"]
    }
  end

  def parse_block_notification(_), do: %{notify_type: :others}

  def parse_contract(contract = %{"code" => code}) do
    contract
    |> Map.merge(code)
    |> Map.delete("code")
    |> parse_contract()
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

  defp parse_token_token(token) do
    %{
      contract_address: parse58(token["contract_address"]),
      decimals: token["decimals"],
      name: parse_string(token["name"]),
      script_hash: parse16(token["script_hash"]),
      symbol: parse_string(token["symbol"])
    }
  end

  def parse_token(token) do
    %{
      block: token["block"],
      contract: parse_contract(token["contract"]),
      token: parse_token_token(token["token"]),
      transaction_hash: parse16(token["tx"]),
      type: token["type"]
    }
  end

  defp parse_string(string), do: String.replace(string, "\u0000", "")
end
