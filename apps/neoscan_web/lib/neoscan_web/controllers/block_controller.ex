defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks

  def index(conn, %{"hash" => block_hash, "page" => page}) do
    {block, transactions} = Blocks.paginate_transactions(block_hash, page)
    route(block, transactions, conn)
  end

  def route(nil, conn) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(block, transactions, conn) do
    clean_transactions = transactions
                          |> Enum.map(fn transaction ->
                            {:ok, result} = Morphix.atomorphiform(transaction)
                            result
                           end)
    render(conn, "block.html", block: block, transactions: clean_transactions)
  end

end
