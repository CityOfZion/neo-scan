defmodule Neoscan.Web.HomeController do
  use Neoscan.Web, :controller
  import Ecto.Query, warn: true


  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Blocks
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Transactions

  def index(conn, _params) do
    block_query = from e in Block,
      order_by: [desc: e.index],
      limit: 10

    transaction_query = from e in Transaction,
      order_by: [desc: e.inserted_at],
      limit: 10

    blocks = Repo.all(block_query)
    transactions = Repo.all(transaction_query)

    render conn, "index.html", blocks: blocks, transactions: transactions
  end

  #searches the database for the input value
  def search(conn, %{"search" => %{"for" => value}}) do
    block =  Blocks.get_block_by_height(value) || Blocks.get_block_by_hash(value)
    transaction =  Transactions.get_transaction_by_hash(value)

    redirect_search_result(conn,block, transaction)
  end

  #redirect search results to correct page
  def redirect_search_result(conn, block, transaction) do
    IO.inspect(block)
    cond  do
      block != nil ->
        redirect(conn, to: block_path(conn, :show_block, block.hash))

      transaction != nil ->
        redirect(conn, to: transaction_path(conn, :show_transaction, transaction.txid))

      true ->
        conn
        |> put_flash(:info, "Block or Transaction not Found in DB!")
        |> redirect(to: home_path(conn, :index))
    end
  end

  #open block page
  def show_block(conn, %{"id" => id}) do
    block = Blocks.get_block!(id)
    render(conn, "block.html", block: block)
  end

  #open transaction page
  def show_transaction(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, "transaction.html", transaction: transaction)
  end


end
