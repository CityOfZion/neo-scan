defmodule NeoscanWeb.AssetsController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api, as: MonitorApi

  def index(conn, _params) do
    assets = MonitorApi.get_assets()
    render(conn, "assets.html", assets: assets)
  end

  def check(value) do
    if value < 0 do
      "Unlimited"
    else
      value
    end
  end
end
