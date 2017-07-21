defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_transaction(conn, %{"txid" => transaction_hash}) do
    transaction = Transactions.get_transaction_by_hash_for_view(transaction_hash)
    render(conn, "transaction.html", transaction: transaction)
  end

  def round_or_not(value) do
    cond do
      Kernel.round(value) == value ->
        Kernel.round(value)
      Kernel.round(value) != value ->
        value
    end
  end

end
