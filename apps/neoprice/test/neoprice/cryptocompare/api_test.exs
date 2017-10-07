defmodule NeoPrice.CryptoCompare.ApiTest do
  @moduledoc "tests on the API"
  use ExUnit.Case
  alias NeoPrice.CryptoCompare.Api

  test "minute report" do
    now = DateTime.utc_now |> DateTime.to_unix()
    prices = Api.get_pricehistorical_price(:minute,  "NEO", "BTC", 1000, now)
    assert_in_delta List.last(prices) |> elem(0), now, 60
  end

  test "hour report" do
    now = DateTime.utc_now |> DateTime.to_unix()
    prices = Api.get_pricehistorical_price(:hour, "NEO", "BTC", 1000, now)
    assert_in_delta List.last(prices) |> elem(0), now, 3600
  end
end
