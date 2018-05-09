defmodule NeoscanWeb.AssetsController do
  use NeoscanWeb, :controller

  alias NeoscanCache.Api, as: CacheApi

  def index(conn, _params) do
    assets = CacheApi.get_assets()
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
