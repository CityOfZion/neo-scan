defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def page(conn, params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    transactions = Transactions.paginate_transactions(page)
    render(conn, "transactions.html", transactions: transactions, page: page, total: 123)
  end
end
