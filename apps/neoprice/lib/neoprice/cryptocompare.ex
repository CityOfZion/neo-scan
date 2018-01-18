defmodule Neoprice.Cryptocompare do
  @moduledoc "Cryptocompare interface"

  alias Neoprice.Cryptocompare.Api

  @limit 2000
  @minute 60
  @hour 3600
  @day 86_400

  @spec last_price(String.t(), String.t()) :: float
  def last_price(from_symbol, to_symbol) do
    Api.last_price(from_symbol, to_symbol)
  end

  @spec last_price_full(String.t(), String.t()) :: float
  def last_price_full(from_symbol, to_symbol) do
    Api.last_price_full(from_symbol, to_symbol)
  end

  @spec get_price(atom, non_neg_integer, non_neg_integer, String.t(), String.t(), non_neg_integer) ::
          list

  def get_price(definition, from, to, from_symbol, to_symbol, aggregate) do
    seconds = seconds(definition)

    :lists.seq(to, from, -seconds * @limit * aggregate)
    |> Enum.reverse()
    |> Enum.map(fn time ->
      limit = limit(from, time, seconds, aggregate)
      Api.get_historical_price(definition, from_symbol, to_symbol, limit, aggregate, time)
    end)
    |> List.flatten()
    |> Enum.filter(fn {k, _} -> k > from and k < to end)
  end

  @spec limit(non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer) ::
          non_neg_integer
  def limit(from, time, definition, aggregate) do
    if from < time - aggregate * definition * @limit do
      @limit
    else
      ((time - from) / (definition * aggregate))
      |> Float.ceil()
      |> round
    end
  end

  defp seconds(:day), do: @day
  defp seconds(:hour), do: @hour
  defp seconds(:minute), do: @minute
  defp seconds(definition), do: raise("Can't convert #{definition}")
end
