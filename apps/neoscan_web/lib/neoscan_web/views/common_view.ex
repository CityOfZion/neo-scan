defmodule NeoscanWeb.CommonView do
  alias NeoscanWeb.Explanations
  alias NeoscanWeb.ViewHelper
  alias Neoscan.Asset
  alias NeoVM.Disassembler

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

  def get_minutes(date_time) do
    if Timex.before?(date_time, Timex.shift(Timex.now(), minutes: -1440)) do
      render_date_time(date_time)
    else
      {:ok, time_string} =
        date_time
        |> Timex.shift([])
        |> Timex.format("{relative}", :relative)

      time_string
    end
  end

  def get_current_min_qtd(_page, total) when total < 15, do: 0
  def get_current_min_qtd(page, _total), do: (page - 1) * 15 + 1

  def get_current_max_qtd(_page, total) when total < 15, do: total
  def get_current_max_qtd(page, total) when page * 15 > total, do: total
  def get_current_max_qtd(page, _total), do: page * 15

  def check_last(page, total), do: page * 15 < total

  def render_asset_style("utility_token"), do: "fa-cubes"
  def render_asset_style("governing_token"), do: "fa-cube"
  def render_asset_style(_), do: "fa-university"

  def render_hash(hash), do: Base.encode16(hash, case: :lower)

  def render_address_hash(hash), do: Base58.encode(hash)

  def render_balance(nil), do: "0"

  def render_balance(%{:value => amount, :precision => precision}),
    do: render_balance(amount, precision)

  def render_balance(%{:value => amount, :asset => %{:precision => precision}}),
    do: render_balance(amount, precision)

  def render_balance(-0.00000001, _), do: "∞"

  def render_balance(amount, precision) do
    balance = Number.Delimit.number_to_delimited(amount, precision: precision)
    render_amount(balance)
  end

  def render_amount(amount) do
    amount
    |> to_string()
    |> remove_trailing()
    |> (&if(&1 == "", do: "0", else: &1)).()
  end

  defp remove_trailing(string) do
    if String.contains?(string, ".") do
      string
      |> String.trim_trailing("0")
      |> String.trim_trailing(".")
    else
      string
    end
  end

  def render_date_time(date_time), do: DateTime.to_unix(date_time)

  def render_asset_name(%{:name => name} = asset) when is_map(name) do
    updated_asset = Asset.update_name(asset)
    updated_asset.name
  end

  def render_asset_name(asset) do
    asset.name
  end

  def check_if_invocation(map) when is_map(map), do: Map.has_key?(map, "invocation")
  def check_if_invocation({"invocation", _hash}), do: true
  def check_if_invocation({:invocation, nil}), do: true
  def check_if_invocation({:invocation, _hash}), do: true
  def check_if_invocation({"verification", _hash}), do: false
  def check_if_invocation({:verification, _hash}), do: false
  def check_if_invocation(nil), do: true
  def check_if_invocation({:id, _}), do: false

  def check_if_verification(map) when is_map(map), do: Map.has_key?(map, "verification")
  def check_if_verification({"verification", _hash}), do: true
  def check_if_verification({:verification, nil}), do: false
  def check_if_verification({:verification, _}), do: true
  def check_if_verification({"invocation", _hash}), do: false
  def check_if_verification({:invocation, _hash}), do: false
  def check_if_verification(nil), do: true
  def check_if_verification({:id, _}), do: false

  def parse_invocation(nil), do: "No Invocation Script"
  def parse_invocation({:invocation, nil}), do: "No Invocation Script"
  def parse_invocation({"invocation", inv}), do: Disassembler.parse_script(inv)
  def parse_invocation({:invocation, inv}), do: Disassembler.parse_script(inv)
  def parse_invocation(%{"invocation" => inv}), do: Disassembler.parse_script(inv)

  def parse_verification(nil), do: "No Verification Script"
  def parse_verification({:verification, nil}), do: "No Verification Script"
  def parse_verification({"verification", ver}), do: Disassembler.parse_script(ver)
  def parse_verification({:verification, ver}), do: Disassembler.parse_script(ver)
  def parse_verification(%{"verification" => ver}), do: Disassembler.parse_script(ver)

  def get_inv(nil), do: "No Invocation Script"
  def get_inv({"invocation", inv}), do: inv
  def get_inv({:invocation, inv}), do: inv
  def get_inv(%{"invocation" => inv}), do: inv

  def get_ver(nil), do: "No Verification Script"
  def get_ver({"verification", ver}), do: ver
  def get_ver({:verification, ver}), do: ver
  def get_ver(%{"verification" => ver}), do: ver

  def get_explanation(topic), do: Explanations.get(topic)
  def get_tooltips(conn), do: ViewHelper.get_tooltips(conn)

  def parse_script(script), do: Disassembler.parse_script(script)
end
