defmodule NeoscanWeb.AssetController do
  use NeoscanWeb, :controller

  alias Neoscan.Assets

  @asset_hash_spec [
    asset_hash: %{
      type: :base16
    }
  ]

  def index(conn, params) do
    if_valid_query conn, params, @asset_hash_spec do
      asset = Assets.get(parsed.asset_hash)

      if is_nil(asset) do
        redirect(conn, to: home_path(conn, :index))
      else
        render(conn, "asset.html", asset: asset)
      end
    end
  end
end
