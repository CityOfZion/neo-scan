defmodule NeoscanWeb.ContractsController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api

  def index(conn, _params) do
    contracts = Api.get_contracts
    render(conn, "contracts.html", contracts: contracts)
  end

end
