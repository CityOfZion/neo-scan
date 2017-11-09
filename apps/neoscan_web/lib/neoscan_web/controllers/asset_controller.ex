defmodule NeoscanWeb.AssetController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api
  alias Neoscan.Transactions
  alias Neoscan.Addresses

  def index(conn, %{"hash" => hash}) do
    asset = Api.get_asset(hash)

    transactions = Transactions.get_last_transactions_for_asset(hash)
                   |> Enum.map(
                        fn tr ->
                          {:ok, result} = Morphix.atomorphiform(tr)
                          result
                        end
                      )
    addresses = Addresses.get_transactions_addresses(transactions)

    render(
      conn,
      "asset.html",
      asset: asset,
      addresses: addresses,
      transactions: transactions
    )
  end

end
