defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions
  alias Neoscan.Counters
  alias NeoscanWeb.Helper

  def page(conn, params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    transactions = Transactions.paginate(page)
    transactions = Helper.render_transactions(transactions)
    total = Counters._count_transactions()
    render(conn, "transactions.html", transactions: transactions, page: page, total: total)
  end
end
