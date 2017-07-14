defmodule Neoscan.Web.HomeController do
  use Neoscan.Web, :controller
  import Ecto.Query, warn: true


  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Blocks
  alias Neoscan.Transactions.Transaction

  def index(conn, _params) do
    updates(conn,[])
  end


  def updates(conn, _params) do
    block_query = from e in Block,
      order_by: [desc: e.index],
      limit: 50

    transaction_query = from e in Transaction,
      order_by: [desc: e.inserted_at],
      limit: 50

    blocks = Repo.all(block_query)
    transactions = Repo.all(transaction_query)

    render conn, "index.html", blocks: blocks, transactions: transactions
  end

  def get_transaction_time(%{:block_id => block_id}) do
    %{:time => time} = Blocks.get_block!(block_id)
    time
  end


end
