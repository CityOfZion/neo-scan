defmodule NeoscanWeb.AssetControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/asset/:asset_hash", %{conn: conn} do
    asset = insert(:asset)

    asset_hash = Base.encode16(asset.transaction_hash, case: :lower)
    conn = get(conn, "/asset/#{asset_hash}")
    assert html_response(conn, 200) =~ asset_hash

    conn = get(conn, "/asset/====")
    assert "/" == redirected_to(conn, 302)
  end
end
