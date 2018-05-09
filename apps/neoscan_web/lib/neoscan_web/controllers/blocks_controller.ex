defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api, as: MonitorApi
  alias Neoscan.Blocks

  def index(conn, _params) do
    blocks = MonitorApi.get_blocks()
    render(conn, "blocks.html", blocks: blocks, page: "1")
  end

  def go_to_page(conn, %{"page" => page}) do
    blocks = Blocks.paginate_blocks(page)
    render(conn, "blocks.html", blocks: blocks, page: page)
  end
end
