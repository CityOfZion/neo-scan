defmodule NeoPrice.CacheTest do
  @moduledoc ""
  use ExUnit.Case
  alias Neoprice.Cache
  @day 86_400

  defmodule StartDateTest do
    @moduledoc false

    use Neoprice.Cache, from_symbol: "GAS", to_symbol: "BTC", config: [], start_day: 1234
  end

  test "start_day/0" do
    assert StartDateTest.start_day() == 1234
  end

  test "init/1" do
    state = %{
      module: %{
        from_symbol: "GAS",
        to_symbol: "BTC",
        start_day: 1234,
        config: [
          %{
            cache_name: :GASUSD_1_d,
            definition: :minute,
            duration: @day,
            aggregation: 1
          }
        ]
      }
    }

    Cache.init(state)
    :ets.delete_all_objects(:GASUSD_1_d)
    :ets.insert(:GASUSD_1_d, {1_500_000_000, 0.006})
    Cache.sync(state)
  end
end
