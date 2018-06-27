defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def index(conn, %{"hash" => transaction_hash}) do
    transaction_hash = Base.decode16!(transaction_hash)
    transaction = Transactions.get(transaction_hash)
    render(conn, "transaction.html", transaction: transaction)
  end
end
