defmodule Neoscan.Web.TransactionController do
  use Neoscan.Web, :controller

  alias Neoscan.Transactions

  def show_transaction(conn, %{"txid" => transaction_hash}) do
    transaction = Transactions.get_transaction_by_hash_for_view(transaction_hash)
    IO.inspect(transaction)
    render(conn, "transaction.html", transaction: transaction)
  end

  def round_or_not(value) do
    IO.puts(value)
    float = case  Kernel.is_float(value) do
      true ->
        value
      false ->
        case Kernel.is_integer(value) do
          true ->
            value
          false ->
          {num, _} = Float.parse(value)
          num
        end
    end

    cond do
      Kernel.round(float) == float ->
        Kernel.round(float)
      Kernel.round(float) != float ->
        value
    end
  end

end
