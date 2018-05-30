defmodule Neoprice.Cryptocompare.HTTPPoisonWrapper do
  @moduledoc "poison wrapper"

  def get(url), do: HTTPoison.get(url)
end
