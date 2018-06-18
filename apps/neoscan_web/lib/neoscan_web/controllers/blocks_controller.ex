defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  def page(conn, parameters) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    blocks = Blocks.paginate_blocks(page)
    render(conn, "blocks.html", blocks: blocks, page: page, total: 124)
  end
end
