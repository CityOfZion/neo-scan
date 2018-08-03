defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias NeoscanWeb.Helper
  alias Neoscan.Transactions

  @address_page_spec [
    address: %{
      type: :base58
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
    if_valid_query conn, params, @address_page_spec do
      address = Addresses.get(parsed.address)

      if is_nil(address) do
        redirect(conn, to: home_path(conn, :index))
      else
        balance = Addresses.get_split_balance(parsed.address)
        transactions = Transactions.get_for_address(parsed.address, parsed.page)
        transactions = Helper.render_transactions(transactions)
        graph_data = Addresses.get_balance_history(parsed.address)

        render(
          conn,
          "address.html",
          address: address,
          balance: balance,
          transactions: transactions,
          page: parsed.page,
          graph_data: graph_data
        )
      end
    end
  end
end
