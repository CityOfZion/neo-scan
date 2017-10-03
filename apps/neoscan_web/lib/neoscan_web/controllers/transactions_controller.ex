defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Transactions

  def index(conn, _params) do
    transactions = Api.get_transactions
                    |> Enum.map(fn transaction ->
                      { :ok, result } = Morphix.atomorphiform(transaction)
                      result
                     end)

    render(conn, "transactions.html", transactions: transactions)
  end

  def go_to_page(conn, %{"page" => page}) do
    transactions = Transactions.paginate_transactions(page)
                    |> Enum.map(fn transaction ->
                      { :ok, result } = Morphix.atomorphiform(transaction)
                      result
                     end)
    render(conn, "transactions.html", transactions: transactions)
  end

end
