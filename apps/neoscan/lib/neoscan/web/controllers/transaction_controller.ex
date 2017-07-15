defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_transaction(conn, %{"id" => transaction_id}) do
    transaction = Transactions.get_transaction!(transaction_id)
    render(conn, "transaction.html", transaction: transaction)
  end

  def no_transaction(conn, _params) do
    render(conn, "transaction.html", transaction: %{})
  end



end
