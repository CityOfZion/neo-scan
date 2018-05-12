defmodule NeoscanWeb.ViewHelper do
  @moduledoc "Contains function used in multiple views"
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Helpers
  alias Plug.Conn

  def get_tooltips(conn) do
    Conn.get_session(conn, "tooltips")
  end

  def get_GAS_balance(nil) do
    raw(
      ~s(<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span><span class="bold-text">GAS: 0.</span><span class="divisible-amount">0</span></p>)
    )
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
      |> Float.to_string()
      |> Integer.parse()

    raw(
      ~s(<p class="medium-detail-text"><span class="fa fa-cubes fa-cubes-small"></span><span class="bold-text">GAS:</span> ) <>
        "#{number_to_delimited(int)}" <>
        ~s(<span class="divisible-amount">) <> "#{div}</span></p>"
    )
  end

  def get_NEO_balance(nil) do
    0
  end

  def get_NEO_balance(balance) do
    balance
    |> Map.to_list()
    |> Enum.filter(fn {_asset, %{"asset" => asset}} ->
      CacheApi.get_asset_name(asset) == "NEO"
    end)
    |> Enum.reduce(0, fn {_asset, %{"amount" => amount}}, _acc -> amount end)
    |> Helpers.round_or_not()
    |> number_to_delimited()
  end

  def compare_time_and_get_minutes(time) do
    date_time =
      time
      |> DateTime.from_unix!()

    case Timex.before?(date_time, Timex.shift(Timex.now(), minutes: -1440)) do
      false ->
        {:ok, time_string} =
          date_time
          |> Timex.shift([])
          |> Timex.format("{relative}", :relative)

        time_string

      true ->
        Timex.format!(date_time, "%Y-%m-%d | %H:%M:%S", :strftime)
    end
  end
end
