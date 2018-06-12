# defmodule NeoscanWeb.PriceControllerTest do
#  use NeoscanWeb.ConnCase
#
#  test "/price/:from/:to/:graph", %{conn: conn} do
#    for from <- ["neo", "gas"],
#        to <- ["usd", "btc"],
#        period <- ["1d", "1w", "1m", "3m", "all"] do
#      conn = get(conn, "/price/#{from}/#{to}/#{period}")
#      assert is_map(json_response(conn, 200))
#    end
#  end
# end
