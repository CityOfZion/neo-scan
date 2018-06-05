defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Transfers
  alias NeoscanWeb.Helper

  def index(conn, %{"hash" => block_hash}) do
    block_hash = Helper.parse_hash(block_hash)
    {block, transactions} = Blocks.paginate_transactions(block_hash, "1")

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

    route(block, transactions, conn, "1")
  end

  def go_to_page(conn, %{"hash" => block_hash, "page" => page}) do
    block_hash = Helper.parse_hash(block_hash)
    {block, transactions} = Blocks.paginate_transactions(block_hash, page)

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

    route(block, transactions, conn, page)
  end

  def route(block, transactions, conn, page) do
    clean_transactions =
      transactions
      |> Enum.map(fn transaction ->
        {:ok, result} = Morphix.atomorphiform(transaction)
        result
      end)

    block = Helper.format_block(block)
    render(conn, "block.html", block: block, transactions: clean_transactions, page: page)
  end
end
