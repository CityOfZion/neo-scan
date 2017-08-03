defmodule NeoscanWeb.ContractsController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def index(conn, _params) do
    contracts = Transactions.list_contracts()
    render(conn, "contracts.html", contracts: contracts)
  end

end
