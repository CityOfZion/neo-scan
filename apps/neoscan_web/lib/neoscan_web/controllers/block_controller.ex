defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Transactions

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, parameters = %{"hash" => block_hash}) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    block_hash = Base.decode16!(block_hash)
    block = Blocks.get(block_hash)
    transactions = Transactions.get_for_block(block_hash, page)
    render(conn, "block.html", block: block, transactions: transactions, page: page)
  end
end
