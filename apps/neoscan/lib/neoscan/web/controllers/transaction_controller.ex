defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_transaction(conn, %{"txid" => transaction_hash}) do
    transaction = Transactions.get_transaction_by_hash(transaction_hash)
    IO.inspect(transaction)
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

  def get_sender(vout, vouts) do
    %{:address_hash => sender} = Enum.at(vouts,vout)
    sender
  end

  def get_amount(vouts) do
    Enum.reduce(vouts, fn (%{:value => value}, acc) -> value + acc end)
  end

end
