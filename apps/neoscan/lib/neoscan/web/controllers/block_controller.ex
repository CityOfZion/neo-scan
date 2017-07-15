defmodule Neoscan.Web.BlockController do
  use Neoscan.Web, :controller

  alias Neoscan.Blocks

  def show_block(conn, %{"id" => block_id}) do
    block = Blocks.get_block!(block_id)
    render(conn, "block.html", block: block)
  end

  def no_block(conn, _params) do
    render(conn, "block.html", block: %{})
  end



end
