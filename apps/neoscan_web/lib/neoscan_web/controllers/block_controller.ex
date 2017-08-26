defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  def index(conn, %{"hash" => block_hash}) do
    Blocks.get_block_by_hash_for_view(block_hash)
    |> route(conn)
  end

  def route(nil, conn) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(block, conn) do
    render(conn, "block.html", block: block)
  end


end
