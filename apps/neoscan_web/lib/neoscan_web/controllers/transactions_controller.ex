defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions
  alias Neoscan.Stats

  def page(conn, params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    transactions = Transactions.paginate_transactions(page)
    total = Stats.count_transactions()
    render(conn, "transactions.html", transactions: transactions, page: page, total: total)
  end
end
