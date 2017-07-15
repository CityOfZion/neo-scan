defmodule Neoscan.Web.BlockController do
  use Neoscan.Web, :controller

  alias Neoscan.Blocks

  def show_block(conn, %{"hash" => block_hash}) do
    block = Blocks.get_block_by_hash(block_hash)
    render(conn, "block.html", block: block)
  end


end
