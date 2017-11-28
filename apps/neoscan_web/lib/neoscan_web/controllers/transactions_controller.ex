defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Transactions

  def index(conn, _params) do
    Api.remove_filtered_count()
    transactions = Api.get_transactions
                    |> Enum.map(fn transaction ->
                      {:ok, result} = Morphix.atomorphiform(transaction)
                      result
                     end)

    render(conn, "transactions.html", transactions: transactions, page: "1", type: nil)
  end

  def go_to_page(conn, %{"page" => page}) do
    Api.remove_filtered_count()
    transactions = Transactions.paginate_transactions(page)
                    |> Enum.map(fn transaction ->
                      {:ok, result} = Morphix.atomorphiform(transaction)
                      result
                     end)

    render(conn, "transactions.html", transactions: transactions, page: page, type: nil)
  end

  def filtered_transactions(conn, %{"type" => type, "page" => page}) do
    transactions = Transactions.paginate_transactions(page, [type])
                    |> Enum.map(fn transaction ->
                      {:ok, result} = Morphix.atomorphiform(transaction)
                      result
                     end)

    render(conn, "transactions.html", transactions: transactions, page: page, type: type)
  end

end
