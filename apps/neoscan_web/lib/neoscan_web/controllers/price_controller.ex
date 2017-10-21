defmodule NeoscanWeb.PriceController do
  @moduledoc "interface to get the prices example:
  price/:from/:to/:graph
  Possible values for from: neo or gas
  Possible values for to: usd or btc
  Possible values for graph: 1d, 1w, 1m, 3m or all
  it return a map of timestamps and values.
  "
  use NeoscanWeb, :controller
  alias Neoprice.NeoBtc
  alias Neoprice.NeoUsd
  alias Neoprice.GasBtc
  alias Neoprice.GasUsd

  def index(conn, %{"from" => from, "graph" => graph, "to" => to}) do
    map = get_graph(from, to, graph)
    json conn, map
  end

  defp get_graph("neo", "usd", "1d"), do: NeoUsd.get_1_day()
  defp get_graph("neo", "usd", "1w"), do: NeoUsd.get_1_week()
  defp get_graph("neo", "usd", "1m"), do: NeoUsd.get_1_month()
  defp get_graph("neo", "usd", "3m"), do: NeoUsd.get_3_month()
  defp get_graph("neo", "usd", "all"), do: NeoUsd.get_all()

  defp get_graph("neo", "btc", "1d"), do: NeoBtc.get_1_day()
  defp get_graph("neo", "btc", "1w"), do: NeoBtc.get_1_week()
  defp get_graph("neo", "btc", "1m"), do: NeoBtc.get_1_month()
  defp get_graph("neo", "btc", "3m"), do: NeoBtc.get_3_month()
  defp get_graph("neo", "btc", "all"), do: NeoBtc.get_all()

  defp get_graph("gas", "usd", "1d"), do: GasUsd.get_1_day()
  defp get_graph("gas", "usd", "1w"), do: GasUsd.get_1_week()
  defp get_graph("gas", "usd", "1m"), do: GasUsd.get_1_month()
  defp get_graph("gas", "usd", "3m"), do: GasUsd.get_3_month()
  defp get_graph("gas", "usd", "all"), do: GasUsd.get_all()

  defp get_graph("gas", "btc", "1d"), do: GasBtc.get_1_day()
  defp get_graph("gas", "btc", "1w"), do: GasBtc.get_1_week()
  defp get_graph("gas", "btc", "1m"), do: GasBtc.get_1_month()
  defp get_graph("gas", "btc", "3m"), do: GasBtc.get_3_month()
  defp get_graph("gas", "btc", "all"), do: GasBtc.get_all()
end
