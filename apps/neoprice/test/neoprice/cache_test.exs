defmodule NeoPrice.CacheTest do
  @moduledoc ""
  use ExUnit.Case

  defmodule StartDateTest do
    @moduledoc false

    use Neoprice.Cache, from_symbol: "GAS", to_symbol: "BTC", config: [], start_day: 1234
  end

  test "start_day/0" do
    assert StartDateTest.start_day == 1234
  end
end
