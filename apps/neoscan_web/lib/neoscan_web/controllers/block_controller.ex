defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  def index(conn, %{"hash" => block_hash}) do
    {block, transactions} = Blocks.paginate_transactions(block_hash, "1")
    route(block, transactions, conn, "1")
  end

  def go_to_page(conn, %{"hash" => block_hash, "page" => page}) do
    {block, transactions} = Blocks.paginate_transactions(block_hash, page)
    route(block, transactions, conn, page)
  end

  def route(nil, _transactions, conn, _page) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end

  def route(block, transactions, conn, page) do
    clean_transactions =
      transactions
      |> Enum.map(fn transaction ->
        {:ok, result} = Morphix.atomorphiform(transaction)
        result
      end)

    render(conn, "block.html", block: block, transactions: clean_transactions, page: page)
  end
end
