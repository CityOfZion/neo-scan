defmodule NeoscanWeb.ApiControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "get_balance/:hash", %{conn: conn} do
    address =
      insert(:address, %{
        balance: %{
          "assethash0" => %{
            "amount" => 50,
            "asset" => "assethash1"
          }
        }
      })

    conn = get(conn, "/api/main_net/v1/get_balance/#{address.address}")

    assert %{
             "address" => address.address,
             "balance" => [
               %{"amount" => 50, "asset" => "Asset not Found", "unspent" => []}
             ]
           } == json_response(conn, 200)
  end
end
