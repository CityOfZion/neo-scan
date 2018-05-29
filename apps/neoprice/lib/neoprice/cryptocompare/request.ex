defmodule Neoprice.Cryptocompare.Request do
  @moduledoc "poison wrapper"

  def get(url), do: HTTPoison.get(url)
end
