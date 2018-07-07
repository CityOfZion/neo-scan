defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Counters

  def page(conn, parameters) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    blocks = Blocks.paginate(page)
    total = Counters.count_blocks()
    render(conn, "blocks.html", blocks: blocks, page: page, total: total)
  end
end
