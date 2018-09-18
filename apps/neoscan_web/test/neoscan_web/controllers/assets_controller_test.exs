defmodule NeoscanWeb.AssetsControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/assets/:page", %{conn: conn} do
    assets = for _ <- 1..20, do: insert(:asset)

    Enum.each(Enum.with_index(assets), fn {%{transaction_hash: transaction_hash}, index} ->
      insert(:counter, %{name: "transactions_by_asset", ref: transaction_hash, value: index})
    end)

    conn = get(conn, "/assets/1")
    body = html_response(conn, 200)
    assert body =~ Base.encode16(Enum.at(assets, 15).transaction_hash, case: :lower)
    assert not (body =~ Base.encode16(Enum.at(assets, 2).transaction_hash, case: :lower))

    conn = get(conn, "/assets/2")
    body = html_response(conn, 200)
    assert not (body =~ Base.encode16(Enum.at(assets, 15).transaction_hash, case: :lower))
    assert body =~ Base.encode16(Enum.at(assets, 2).transaction_hash, case: :lower)

    conn = get(conn, "/assets/====")
    assert "/" == redirected_to(conn, 302)
  end
end
