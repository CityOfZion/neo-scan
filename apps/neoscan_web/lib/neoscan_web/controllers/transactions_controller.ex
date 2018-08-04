defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions
  alias Neoscan.Counters
  alias NeoscanWeb.Helper

  @page_spec [
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def page(conn, params) do
    if_valid_query conn, params, @page_spec do
      transactions = Transactions.paginate(parsed.page)
      transactions = Helper.render_transactions(transactions)
      total = Counters._count_transactions()

      render(
        conn,
        "transactions.html",
        transactions: transactions,
        page: parsed.page,
        total: total
      )
    end
  end
end
