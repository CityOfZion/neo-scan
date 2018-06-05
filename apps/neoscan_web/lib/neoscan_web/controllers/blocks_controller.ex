defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Blocks
  alias NeoscanWeb.Helper

  def index(conn, _params) do
    blocks = CacheApi.get_blocks()
    blocks = Helper.format_blocks(blocks)
    render(conn, "blocks.html", blocks: blocks, page: "1")
  end

  def go_to_page(conn, %{"page" => page}) do
    blocks = Blocks.paginate_blocks(page)
    blocks = Helper.format_blocks(blocks)
    render(conn, "blocks.html", blocks: blocks, page: page)
  end
end
