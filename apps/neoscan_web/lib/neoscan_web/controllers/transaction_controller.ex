defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions
  alias NeoscanWeb.Helper

  def index(conn, %{"hash" => transaction_hash}) do
    transaction_hash = Base.decode16!(transaction_hash, case: :mixed)
    transaction = Transactions.get(transaction_hash)
    transaction = Helper.render_transaction(transaction)
    render(conn, "transaction.html", transaction: transaction)
  end
end
