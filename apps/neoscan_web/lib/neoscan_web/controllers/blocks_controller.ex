defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Counters

  @page_spec [
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def page(conn, params) do
    if_valid_query conn, params, @page_spec do
      blocks = Blocks.paginate(parsed.page)
      total = Counters.count_blocks()
      render(conn, "blocks.html", blocks: blocks, page: parsed.page, total: total)
    end
  end
end
