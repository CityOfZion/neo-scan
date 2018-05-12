defmodule NeoscanWeb.AssetView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanWeb.ViewHelper
  alias Neoscan.Helpers
  alias NeoscanCache.Api, as: CacheApi

  def compare_time_and_get_minutes(balance) do
    unix_time =
      Map.to_list(balance)
      |> Enum.reduce([], fn {_asset, %{"time" => time}}, acc ->
        [time | acc]
      end)
      |> Enum.max()

    ViewHelper.compare_time_and_get_minutes(unix_time)
  end

  def get_NEO_balance(balance) do
    ViewHelper.get_NEO_balance(balance)
  end

  def get_GAS_balance(balance) do
    ViewHelper.get_GAS_balance(balance)
  end

  def get_class(type) do
    cond do
      type == "ContractTransaction" ->
        'neo-transaction'

      type == "ClaimTransaction" ->
        'gas-transaction'

      type == "IssueTransaction" ->
        'issue-transaction'

      type == "RegisterTransaction" ->
        'register-transaction'

      type == "InvocationTransaction" ->
        'invocation-transaction'

      type == "EnrollmentTransaction" ->
        'invocation-transaction'

      type == "StateTransaction" ->
        'invocation-transaction'

      type == "PublishTransaction" ->
        'publish-transaction'

      type == "MinerTransaction" ->
        'miner-transaction'
    end
  end

  def check(value) do
    if value < 0 do
      "Unlimited"
    else
      value
      |> Helpers.round_or_not()
      |> number_to_delimited()
    end
  end
end
