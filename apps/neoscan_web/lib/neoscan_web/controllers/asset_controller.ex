defmodule NeoscanWeb.AssetController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api

  def index(conn, %{"hash" => hash}) do
    asset = Api.get_asset(hash)
    render(conn, "asset.html", asset: asset)
  end

  def check(value) do
    if value < 0 do
      "Unlimited"
    else
      value
    end
  end

end
