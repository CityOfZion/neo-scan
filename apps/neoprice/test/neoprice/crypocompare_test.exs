defmodule NeoPrice.CryptoCompareTest do
  @moduledoc "tests on the API"
  use ExUnit.Case
  alias Neoprice.Cryptocompare

  test "last_price/2" do
    assert is_number(Cryptocompare.last_price("NEO", "BTC"))
  end

  test "last_price_full/2" do
    assert is_map(Cryptocompare.last_price_full("NEO", "BTC"))
  end

  test "minute prices" do
    now = DateTime.utc_now()
          |> DateTime.to_unix()
    from = now - 3600 * 24
    prices = Cryptocompare.get_price(:minute, from, now, "NEO", "BTC", 1)
    assert_in_delta length(prices), 1440, 2
    assert_in_delta List.last(prices)
                    |> elem(0), now, 60
  end

  test "hour prices" do
    now = DateTime.utc_now()
          |> DateTime.to_unix()
    from = now - 3600 * 24
    prices = Cryptocompare.get_price(:hour, from, now, "NEO", "BTC", 1)
    assert length(prices) == 24
    assert_in_delta List.last(prices)
                    |> elem(0), now, 3600
  end

  test "limit" do
    assert Cryptocompare.limit(140_000_000, 150_000_000, 60, 1) == 2000
    assert Cryptocompare.limit(150_000_000, 150_000_300, 60, 1) == 5
    assert Cryptocompare.limit(150_000_000, 150_000_030, 60, 1) == 1
  end

  test "wrong definition" do
    now = DateTime.utc_now()
          |> DateTime.to_unix()
    from = now - 3600 * 24
    assert_raise RuntimeError,
                 ~r/^Can't convert/,
                 fn -> Cryptocompare.get_price(:lightyear, from, now, "NEO", "BTC", 1) end
  end
end
