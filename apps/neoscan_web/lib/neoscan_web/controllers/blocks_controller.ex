defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  @page_spec [
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def page(conn, params) do
    if_valid_query conn, params, @page_spec do
      blocks = Blocks.paginate(parsed.page)
      render(conn, "blocks.html", blocks: blocks, page: parsed.page, total: blocks.total_entries)
    end
  end
end
