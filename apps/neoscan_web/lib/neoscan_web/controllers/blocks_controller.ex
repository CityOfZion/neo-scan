defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Blocks

  def index(conn, _params) do
    blocks = Api.get_blocks
    render(conn, "blocks.html", blocks: blocks)
  end

  def go_to_page(conn, %{"page" => page}) do
    blocks = Blocks.paginate_blocks(page)
    render(conn, "blocks.html", blocks: blocks)
  end

end
