defmodule NeoscanWeb.AssetView do
  use NeoscanWeb, :view
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers

  def compare_time_and_get_minutes(balance) do

    unix_time = Map.to_list(balance)
    |> Enum.reduce([], fn ({_asset, %{"time" => time}}, acc) ->
         [time | acc]
       end)
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

  def get_NEO_balance(nil) do
   0
  end
  def get_NEO_balance(balance) do
    balance
    |> Map.to_list
    |> Enum.filter(fn {_asset, %{"asset" => asset}} ->
         Api.get_asset_name(asset) == "NEO"
       end)
    |> Enum.reduce(0, fn ({_asset, %{"amount" => amount}}, _acc) -> amount end)
    |> Helpers.round_or_not
  end

  def get_GAS_balance(nil) do
   raw('<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span>GAS: 0.<span class="divisible-amount">#{0}</span></p>')
  end
  def get_GAS_balance(balance) do
    {int, div} = balance
                  |> Map.to_list
                  |> Enum.filter(fn {_asset, %{"asset" => asset}} ->
                       Api.get_asset_name(asset) == "GAS"
                     end)
                  |> Enum.reduce(0.0, fn ({_asset, %{"amount" => amount}}, acc) ->
                       amount + acc
                     end)
                  |> Float.to_string
                  |> Integer.parse

    raw('<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span>GAS: #{int}<span class="divisible-amount">#{div}</span></p>')
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
