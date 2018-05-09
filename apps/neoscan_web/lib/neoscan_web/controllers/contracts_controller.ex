defmodule NeoscanWeb.ContractsController do
  use NeoscanWeb, :controller

  alias NeoscanCache.Api, as: CacheApi

  def index(conn, _params) do
    contracts = CacheApi.get_contracts()
    render(conn, "contracts.html", contracts: contracts)
  end
end
