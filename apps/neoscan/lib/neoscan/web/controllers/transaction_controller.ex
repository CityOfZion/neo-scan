defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_transaction(conn, %{"txid" => transaction_hash}) do
    transaction = Transactions.get_transaction_by_hash(transaction_hash)
    render(conn, "transaction.html", transaction: transaction)
  end


end
