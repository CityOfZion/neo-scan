defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Stats

  def page(conn, parameters) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    blocks = Blocks.paginate_blocks(page)
    total = Stats.count_blocks()
    render(conn, "blocks.html", blocks: blocks, page: page, total: total)
  end
end
