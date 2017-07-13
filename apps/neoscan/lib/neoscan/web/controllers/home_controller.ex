defmodule Neoscan.Web.HomeController do
  use Neoscan.Web, :controller

  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Transactions.Transaction

    def index(conn, _params) do
    blocks = Repo.all(Block)
    transactions = Repo.all(Transaction)
    render conn, "index.html", blocks: blocks, transactions: transactions
  end
end
