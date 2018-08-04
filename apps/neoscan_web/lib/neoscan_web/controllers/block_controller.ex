defmodule NeoscanWeb.BlockController do
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias NeoscanWeb.Helper

  @block_hash_page_spec [
    block_hash: %{
      type: :integer_or_base16
    },
    page: %{
      type: :integer,
      default: 1
    }
  ]

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, params) do
    if_valid_query conn, params, @block_hash_page_spec do
      block = Blocks.get(parsed.block_hash)

      if is_nil(block) do
        redirect(conn, to: home_path(conn, :index))
      else
        transactions = Transactions.get_for_block(block.hash, parsed.page)
        transactions = Helper.render_transactions(transactions)
        render(conn, "block.html", block: block, transactions: transactions, page: parsed.page)
      end
    end
  end
end
