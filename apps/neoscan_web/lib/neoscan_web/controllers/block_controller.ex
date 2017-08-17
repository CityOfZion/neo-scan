defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  def index(conn, %{"hash" => block_hash}) do
    block = Blocks.get_block_by_hash_for_view(block_hash)
    render(conn, "block.html", block: block)
  end


end
