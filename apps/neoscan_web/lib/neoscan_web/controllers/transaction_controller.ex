defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def index(conn, %{"hash" => transaction_hash}) do
    transaction_hash = Base.decode16!(transaction_hash)
    transaction = Transactions.get_transaction_by_hash_for_view(transaction_hash)
    IO.inspect(transaction)
    render(conn, "transaction.html", transaction: transaction)
  end
end
