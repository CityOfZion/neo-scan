defmodule NeoscanWeb.PriceController do
  @moduledoc "interface to get the prices example:
  price/:from/:to/:graph
  Possible values for from: neo or gas
  Possible values for to: usd or btc
  Possible values for graph: 1d, 1w, 1m, 3m or all
  it return a map of timestamps and values.
  "
  use NeoscanWeb, :controller
  alias NeoscanCache.Cache

  def index(conn, %{"from" => from, "graph" => graph, "to" => to}) do
    map = get_graph(from, to, graph)
    json(conn, map)
  end

  defp get_graph(from, to, definition) do
    Cache.get_price_history(String.upcase(from), String.upcase(to), definition) || %{}
  end
end
