defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def index(conn, %{"txid" => transaction_hash}) do
    Transactions.get_transaction_by_hash_for_view(transaction_hash)
    |> route(conn)
  end

  def route(nil, conn) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(transaction, conn) do
    render(conn, "transaction.html", transaction: transaction)
  end

  def round_or_not(value) do
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
