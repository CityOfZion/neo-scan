defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Transactions

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, parameters = %{"hash" => hash_or_integer}) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    hash_or_integer = parse_index_or_hash(hash_or_integer)
    block = Blocks.get(hash_or_integer)
    transactions = Transactions.get_for_block(block.hash, page)
    render(conn, "block.html", block: block, transactions: transactions, page: page)
  end

  defp parse_index_or_hash(value) do
    case Integer.parse(value) do
      {integer, ""} ->
        integer

      _ ->
        Base.decode16!(value)
    end
  end
end
