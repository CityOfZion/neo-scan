defmodule NeoscanWeb.TransactionsController do
  use NeoscanWeb, :controller

  alias NeoscanCache.Api, as: CacheApi
  alias Neoscan.Transactions
  alias Neoscan.Transfers

  def index(conn, _params) do
    transactions =
      CacheApi.get_transactions()
      |> Enum.map(fn transaction ->
        {:ok, result} = Morphix.atomorphiform(transaction)
        result
      end)

    transfers =
      Enum.map(transactions, fn tx -> tx.txid end)
      |> Transfers.get_transactions_transfers()

    transactions =
      transactions
      |> Enum.map(fn tx ->
        Map.merge(tx, %{
          :transfers =>
            Enum.filter(transfers, fn transfer ->
              transfer.txid == tx.txid
            end) || []
        })
      end)

    render(conn, "transactions.html", transactions: transactions, page: "1", type: nil)
  end

  def go_to_page(conn, %{"page" => page}) do
    transactions =
      Transactions.paginate_transactions(page)
      |> Enum.map(fn transaction ->
        {:ok, result} = Morphix.atomorphiform(transaction)
        result
      end)

    transfers =
      Enum.map(transactions, fn tx -> tx.txid end)
      |> Transfers.get_transactions_transfers()

    transactions =
      transactions
      |> Enum.map(fn tx ->
        Map.merge(tx, %{
          :transfers =>
            Enum.filter(transfers, fn transfer ->
              transfer.txid == tx.txid
            end) || []
        })
      end)

    render(conn, "transactions.html", transactions: transactions, page: page, type: nil)
  end

  def filtered_transactions(conn, %{"type" => type, "page" => page}) do
    transactions =
      Transactions.paginate_transactions(page, [type])
      |> Enum.map(fn transaction ->
        {:ok, result} = Morphix.atomorphiform(transaction)
        result
      end)

    transfers =
      Enum.map(transactions, fn tx -> tx.txid end)
      |> Transfers.get_transactions_transfers()

    transactions =
      transactions
      |> Enum.map(fn tx ->
        Map.merge(tx, %{
          :transfers =>
            Enum.filter(transfers, fn transfer ->
              transfer.txid == tx.txid
            end) || []
        })
      end)

    render(conn, "transactions.html", transactions: transactions, page: page, type: type)
  end
end
