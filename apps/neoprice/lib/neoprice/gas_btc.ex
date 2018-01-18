defmodule Neoprice.GasBtc do
  @moduledoc false

  @day 86_400
  @month 2_678_400

  alias Neoprice.Cache.Config

  use Neoprice.Cache,
    from_symbol: "GAS",
    to_symbol: "BTC",
    config: [
      %Config{
        cache_name: :GASBTC_all,
        definition: :day,
        duration: :start,
        aggregation: 1
      },
      %Config{
        cache_name: :GASBTC_3_m,
        definition: :hour,
        duration: @month * 3,
        aggregation: 3
      },
      %Config{
        cache_name: :GASBTC_1_m,
        definition: :hour,
        duration: @month,
        aggregation: 1
      },
      %Config{
        cache_name: :GASBTC_1_w,
        definition: :minute,
        duration: 7 * @day,
        aggregation: 15
      },
      %Config{
        cache_name: :GASBTC_1_d,
        definition: :minute,
        duration: @day,
        aggregation: 1
      }
    ]

  def get_all, do: :ets.tab2list(:GASBTC_all) |> Map.new()
  def get_3_month, do: :ets.tab2list(:GASBTC_3_m) |> Map.new()
  def get_1_month, do: :ets.tab2list(:GASBTC_1_m) |> Map.new()
  def get_1_week, do: :ets.tab2list(:GASBTC_1_w) |> Map.new()
  def get_1_day, do: :ets.tab2list(:GASBTC_1_d) |> Map.new()
end
