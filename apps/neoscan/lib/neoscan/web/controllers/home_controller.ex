defmodule Neoscan.Web.HomeController do
  use Neoscan.Web, :controller
  import Ecto.Query, warn: true


  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Blocks
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Transactions

  #load last blocks and transactions from db
  def index(conn, _params) do
    block_query = from e in Block,
      order_by: [desc: e.index],
      limit: 50

    transaction_query = from e in Transaction,
      order_by: [desc: e.inserted_at],
      where: e.type != "MinerTransaction",
      limit: 50

    blocks = Repo.all(block_query)
    transactions = Repo.all(transaction_query)

    render conn, "index.html", blocks: blocks, transactions: transactions
  end

  #searches the database for the input value
  def search(conn, %{"search" => %{"for" => value}}) do
    result = try  do
      String.to_integer(value)
    rescue
      ArgumentError ->
        Blocks.get_block_by_hash(value) || Transactions.get_transaction_by_hash(value)
    else
      value ->
        Blocks.get_block_by_height(value)
    end

    redirect_search_result(conn, result)
  end

  #redirect search results to correct page
  def redirect_search_result(conn, result) do
    cond  do
      nil == result ->
        conn
        |> put_flash(:info, "Block or Transaction not Found in DB!")
        |> redirect(to: home_path(conn, :index))

      Map.has_key?(result, :hash) ->
        redirect(conn, to: block_path(conn, :show_block, result.hash))

      Map.has_key?(result, :txid) ->
        redirect(conn, to: transaction_path(conn, :show_transaction, result.txid))

    end
  end

end
