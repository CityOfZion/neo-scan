defmodule NeoscanWeb.AssetView do
  use NeoscanWeb, :view
  alias NeoscanMonitor.Api
  alias NeoscanWeb.ViewHelper
  alias Neoscan.Helpers

  def compare_time_and_get_minutes(balance) do

    unix_time = Map.to_list(balance)
                |> Enum.reduce(
                     [],
                     fn ({_asset, %{"time" => time}}, acc) ->
                       [time | acc]
                     end
                   )
                |> Enum.max

    ecto_time = Ecto.DateTime.from_unix!(unix_time, :second)

    [dt1, dt2] = [ecto_time, Ecto.DateTime.utc]
                 |> Enum.map(&Ecto.DateTime.to_erl/1)
                 |> Enum.map(&NaiveDateTime.from_erl!/1)
                 |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))
                 |> Enum.map(&DateTime.to_unix(&1))

    {int, _str} = (dt2 - dt1) / 60
                  |> Float.floor(0)
                  |> Float.to_string
                  |> Integer.parse

    int
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
      type == "PublishTransaction" ->
        'publish-transaction'
    end
  end

  def check(value) do
    if value < 0 do
      "Unlimited"
    else
      value
    end
  end

end
