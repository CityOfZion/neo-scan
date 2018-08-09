defmodule NeoscanWeb.AssetsController do
  use NeoscanWeb, :controller

  alias Neoscan.Assets
  alias Neoscan.Counters

  @page_spec [
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def page(conn, params) do
    if_valid_query conn, params, @page_spec do
      assets = Assets.paginate(parsed.page)
      total = Counters.count_assets()
      render(conn, "assets.html", assets: assets, page: parsed.page, total: total)
    end
  end
end
