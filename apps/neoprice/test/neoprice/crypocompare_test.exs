defmodule NeoPrice.CryptoCompareTest do
  @moduledoc "tests on the API"
  use ExUnit.Case
  alias Neoprice.Cryptocompare
  @seconds_in_a_week 604800

  test "minute prices" do
    now = DateTime.utc_now |> DateTime.to_unix()
    from = now - @seconds_in_a_week
    prices = Cryptocompare.minute_prices(from, now, "NEO", "BTC")
    assert_in_delta length(prices), 10080, 11 # seems like for a reason their are more than 1080 results
    assert_in_delta List.last(prices) |> elem(0), now, 60
  end

  test "hour prices" do
    now = DateTime.utc_now |> DateTime.to_unix()
    from = now - @seconds_in_a_week
    prices = Cryptocompare.hour_prices(from, now, "NEO", "BTC")
    assert_in_delta length(prices), 168, 1
    assert_in_delta List.last(prices) |> elem(0), now, 3600
  end

  test "last two weeks" do
    now = DateTime.utc_now |> DateTime.to_unix()
    from = now - 2 * @seconds_in_a_week
    prices = Cryptocompare.last_two_week("NEO", "BTC")
    assert_in_delta length(prices), 10248, 11
    assert_in_delta List.last(prices) |> elem(0), now, 60
    assert_in_delta List.first(prices) |> elem(0), from, 3600
  end
end
