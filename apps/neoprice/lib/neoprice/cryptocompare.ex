defmodule Neoprice.Cryptocompare do
  @moduledoc "Cryptocompare interface"
  alias NeoPrice.CryptoCompare.Api
  @seconds_in_a_week 604800
  @limit 1000

  def last_two_week(from_symbol, to_symbol) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    a_week_ago = now - @seconds_in_a_week
    two_weeks_ago = now - 2 * @seconds_in_a_week
    minute_prices = minute_prices(a_week_ago, now, from_symbol, to_symbol)
    hour_prices = hour_prices(two_weeks_ago, a_week_ago, from_symbol, to_symbol)
    hour_prices ++ minute_prices
  end

  def hour_prices(from, to, from_symbol, to_symbol) do
    :lists.seq(to, from, -3600 * @limit)
    |> Enum.reverse()
    |> Enum.map(fn(time) ->
       Task.async(fn ->
         Api.get_pricehistorical_price(:hour, from_symbol,
                                       to_symbol, @limit, time)
       end)
    end)
    |> Enum.map(&Task.await(&1, 30_000))
    |> List.flatten()
    |> Enum.filter(fn({k,_}) -> k > from and k < to end)
  end

  def minute_prices(from, to, from_symbol, to_symbol) do
    :lists.seq(to, from, -60 * @limit)
    |> Enum.reverse()
    |> Enum.map(fn(time) ->
      Task.async(fn ->
        Api.get_pricehistorical_price(:minute, from_symbol,
                                      to_symbol, @limit, time)
      end)
    end)
    |> Enum.map(&Task.await(&1, 30_000))
    |> List.flatten()
    |> Enum.filter(fn({k,_}) -> k > from and k < to end)
  end
end
