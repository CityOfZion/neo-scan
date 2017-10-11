defmodule NeoPrice.CryptoCompareTest do
  @moduledoc "tests on the API"
  use ExUnit.Case
  alias Neoprice.Cryptocompare

  test "minute prices" do
    now = DateTime.utc_now |> DateTime.to_unix()
    from = now - 3600 * 24
    prices = Cryptocompare.minute_prices(from, now, "NEO", "BTC", 1)
    IO.inspect(length(prices))
    assert_in_delta length(prices), 1440, 2
    assert_in_delta List.last(prices) |> elem(0), now, 60
  end

  test "hour prices" do
    now = DateTime.utc_now |> DateTime.to_unix()
    from = now - 3600 * 24
    prices = Cryptocompare.hour_prices(from, now, "NEO", "BTC", 1)
    assert length(prices) == 24
    assert_in_delta List.last(prices) |> elem(0), now, 3600
  end

  test "limit" do
    assert Cryptocompare.limit(140000000, 150000000, 60, 1) == 2000
    assert Cryptocompare.limit(150000000, 150000300, 60, 1) == 5
    assert Cryptocompare.limit(150000000, 150000030, 60, 1) == 1
  end
end
