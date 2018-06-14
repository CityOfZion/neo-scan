defmodule NeoscanWeb.AddressView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Helpers
  alias Neoscan.Assets

  def get_transaction_name("contract_transaction"), do: "Contract"
  def get_transaction_name("claim_transaction"), do: "Gas Claim"
  def get_transaction_name("invocation_transaction"), do: "Invocation"
  def get_transaction_name("enrollment_transaction"), do: "Enrollment"
  def get_transaction_name("state_transaction"), do: "State"
  def get_transaction_name("issue_transaction"), do: "Asset Issue"
  def get_transaction_name("register_transaction"), do: "Asset Register"
  def get_transaction_name("publish_transaction"), do: "Contract Publish"
  def get_transaction_name("miner_transaction"), do: "Miner"

  def get_transaction_style("contract_transaction"), do: "fa-cube"
  def get_transaction_style("claim_transaction"), do: "fa-cubes"
  def get_transaction_style("invocation_transaction"), do: "fa-paper-plane"
  def get_transaction_style("enrollment_transaction"), do: "fa-paper-plane"
  def get_transaction_style("state_transaction"), do: "fa-paper-plane"
  def get_transaction_style("issue_transaction"), do: "fa-handshake-o"
  def get_transaction_style("register_transaction"), do: "fa-list-alt"
  def get_transaction_style("publish_transaction"), do: "fa-cube"
  def get_transaction_style("miner_transaction"), do: "fa-user-circle-o"

  def get_class("contract_transaction"), do: "neo-transaction"
  def get_class("claim_transaction"), do: "gas-transaction"
  def get_class("invocation_transaction"), do: "invocation-transaction"
  def get_class("enrollment_transaction"), do: "invocation-transaction"
  def get_class("state_transaction"), do: "invocation-transaction"
  def get_class("issue_transaction"), do: "issue-transaction"
  def get_class("register_transaction"), do: "register-transaction"
  def get_class("publish_transaction"), do: "publish-transaction"
  def get_class("miner_transaction"), do: "miner-transaction"

  def base16(binary) do
    Base.encode16(binary)
  end

  def get_GAS_balance(nil) do
    raw('<p class="balance-amount">0<span>#{0}</span></p>')
  end

  def get_GAS_balance(balance) do
    {int, div} =
      balance
      |> Map.to_list()
      |> Enum.filter(fn {_asset, %{"asset" => asset}} ->
        CacheApi.get_asset_name(asset) == "GAS"
      end)
      |> Enum.reduce(0.0, fn {_asset, %{"amount" => amount}}, acc ->
        amount + acc
      end)
      |> Float.round(8)
      |> :erlang.float_to_binary(decimals: 8)
      |> String.trim_trailing("0")
      |> String.trim_trailing(".")
      |> Integer.parse()

    raw('<p class="balance-amount">#{number_to_delimited(int)}<span>#{div}</span></p>')
  end

  def get_token_balance(token) do
    precision = Assets.get_asset_precision_by_hash(token["asset"])

    {int, div} =
      token
      |> Map.get("amount")
      |> Helpers.apply_precision(token["asset"], precision)
      |> Integer.parse()

    raw('<p class="balance-amount">#{number_to_delimited(int)}<span>#{div}</span></p>')
  end

  def get_current_min_qtd(_page, total) when total < 15, do: 0
  def get_current_min_qtd(page, _total), do: (page - 1) * 15 + 1

  def get_current_max_qtd(_page, total) when total < 15, do: total
  def get_current_max_qtd(page, total) when page * 15 > total, do: total
  def get_current_max_qtd(page, _total), do: page * 15

  def check_last(page, total), do: page * 15 < total

  def apply_precision(asset, amount) do
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
