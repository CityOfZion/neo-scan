defmodule NeoscanWeb.CommonView do
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

  def render_asset_style(asset_hash) do
    case render_asset_name(asset_hash) do
      "GAS" ->
        "fa-cubes"

      "NEO" ->
        "fa-cube"

      _ ->
        "fa-university"
    end
  end

  def render_asset_name(asset_hash) do
    NeoscanCache.Api.get_asset_name(asset_hash)
  end

  def render_hash(hash), do: Base.encode16(hash)

  def render_address_hash(hash), do: Base58.encode(hash)

  def render_token_balance(amount, precision) when is_integer(precision) do
    render_balance(amount / :math.pow(10, precision), precision)
  end

  def render_token_balance(amount, asset_hash) do
    precision = NeoscanCache.Api.get_asset_precision(asset_hash)
    render_token_balance(amount, precision)
  end

  def render_balance(-0.00000001, _), do: "∞"

  def render_balance(amount, precision) when is_integer(precision) do
    balance = Number.Delimit.number_to_delimited(amount, precision: precision)
    render_amount(balance)
  end

  def render_balance(amount, asset_hash) do
    precision = NeoscanCache.Api.get_asset_precision(asset_hash)
    render_balance(amount, precision)
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

  def render_date_time(date_time) do
    remove_trailing("#{DateTime.to_date(date_time)} | #{DateTime.to_time(date_time)}")
  end
end
