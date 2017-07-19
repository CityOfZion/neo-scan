defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions
  alias Neoscan.Repo

  def show_transaction(conn, %{"txid" => transaction_hash}) do
    transaction = Transactions.get_transaction_by_hash(transaction_hash)
    |> Repo.preload(:vouts)
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
