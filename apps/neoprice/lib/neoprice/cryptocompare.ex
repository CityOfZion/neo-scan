defmodule Neoprice.Cryptocompare do
  @moduledoc "Cryptocompare interface"
  alias Neoprice.Cryptocompare.Api
  @limit 2000
  @minute 60
  @hour 3600
  @day 86_400

  def last_price(from_symbol, to_symbol) do
    Api.last_price(from_symbol, to_symbol)
  end

  def day_definition(from, to, from_symbol, to_symbol) do
    day_prices(from, to, from_symbol, to_symbol, 1)
  end

  def three_hours_definition(from, to, from_symbol, to_symbol) do
    hour_prices(from, to, from_symbol, to_symbol, 3)
  end

  def hour_definition(from, to, from_symbol, to_symbol) do
    hour_prices(from, to, from_symbol, to_symbol, 1)
  end

  def fifteen_minute_definition(from, to, from_symbol, to_symbol) do
    minute_prices(from, to, from_symbol, to_symbol, 15)
  end

  def minute_definition(from, to, from_symbol, to_symbol) do
    minute_prices(from, to, from_symbol, to_symbol, 1)
  end

  def day_prices(from, to, from_symbol, to_symbol, aggregate) do
    :lists.seq(to, from, -@day * @limit * aggregate)
    |> Enum.reverse()
    |> Enum.map(fn(time) ->
      limit = limit(from, time, @day, aggregate)
      Api.get_historical_price(:day, from_symbol, to_symbol,
                                limit, aggregate, time)
    end)
    |> List.flatten()
    |> Enum.filter(fn({k,_}) -> k > from and k < to end)
  end

  def hour_prices(from, to, from_symbol, to_symbol, aggregate) do
    :lists.seq(to, from, -@hour * @limit * aggregate)
    |> Enum.reverse()
    |> Enum.map(fn(time) ->
      limit = limit(from, time, @hour, aggregate)
       Api.get_historical_price(:hour, from_symbol,
                                to_symbol, limit, aggregate, time)
    end)
    |> List.flatten()
    |> Enum.filter(fn({k,_}) -> k > from and k < to end)
  end

  def minute_prices(from, to, from_symbol, to_symbol, aggregate) do
    :lists.seq(to, from, -@minute * @limit * aggregate)
    |> Enum.reverse()
    |> Enum.map(fn(time) ->
      limit = limit(from, time, @minute, aggregate)
      Api.get_historical_price(:minute, from_symbol,
                               to_symbol, limit, aggregate, time)
    end)
    |> List.flatten()
    |> Enum.filter(fn({k,_}) -> k > from and k < to end)
  end


  def limit(from, time, definition, aggregate) do
    if from < time - aggregate * definition * @limit do
      @limit
    else
      (time - from) / (definition * aggregate)
      |> Float.ceil() |> round
    end
  end
end
