defmodule NeoscanWeb.ContractsController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api, as: MonitorApi

  def index(conn, _params) do
    contracts = MonitorApi.get_contracts()
    render(conn, "contracts.html", contracts: contracts)
  end
end
