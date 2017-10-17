defmodule Neoprice.GasUsd do
  @moduledoc false

  @day 86400
  @month 2678400

  alias Neoprice.Cache.Config
  use Neoprice.Cache,
      from_symbol: "GAS",
      to_symbol: "USD",
      config: [
        %Config{
          cache_name: :GASUSD_day,
          definition: :day,
          duration: :start,
          aggregation: 1
        },
        %Config{
          cache_name: :GASUSD_3_m,
          definition: :hour,
          duration: @month * 3,
          aggregation: 3
        },
        %Config{
          cache_name: :GASUSD_1_m,
          definition: :hour,
          duration: @month,
          aggregation: 1
        },
        %Config{
          cache_name: :GASUSD_1_w,
          definition: :minute,
          duration: 7 * @day,
          aggregation: 15
        },
        %Config{
          cache_name: :GASUSD_1_d,
          definition: :minute,
          duration: @day,
          aggregation: 1
        }
      ]
  def get_day(), do: :ets.tab2list(:GASUSD_day) |> Map.new
  def get_3_month(), do: :ets.tab2list(:GASUSD_3_m) |> Map.new
  def get_1_month(), do: :ets.tab2list(:GASUSD_1_m) |> Map.new
  def get_1_week(), do: :ets.tab2list(:GASUSD_1_w) |> Map.new
  def get_1_day(), do: :ets.tab2list(:GASUSD_1_d) |> Map.new
end
