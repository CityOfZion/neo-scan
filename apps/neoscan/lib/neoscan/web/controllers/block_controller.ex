defmodule Neoscan.Web.BlockController do
  use Neoscan.Web, :controller
  import Ecto.Query, warn: false

  alias Neoscan.Blocks
  alias Neoscan.Repo

  def show_block(conn, %{"hash" => block_hash}) do
    block = Blocks.get_block_by_hash(block_hash)
    |> Repo.preload(:transactions)
    render(conn, "block.html", block: block)
  end


end
