defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions
  alias NeoscanWeb.Helper

  @transaction_hash_spec [
    transaction_hash: %{
      type: :base16
    }
  ]

  def index(conn, params) do
    if_valid_query conn, params, @transaction_hash_spec do
      transaction = Transactions.get(parsed.transaction_hash)

      if is_nil(transaction) do
        redirect(conn, to: home_path(conn, :index))
      else
        transaction = Helper.render_transaction(transaction)
        render(conn, "transaction.html", transaction: transaction)
      end
    end
  end
end
