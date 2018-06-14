defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses
  alias NeoscanWeb.Helper
  #  alias Neoscan.BalanceHistories

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  @gas_asset_hash <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16, 132,
                    227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45, 231>>

  def index(conn, parameters) do
    page(conn, parameters)
  end

  def page(conn, parameters = %{"address" => address_hash}) do
    page = if is_nil(parameters["page"]), do: 1, else: String.to_integer(parameters["page"])
    binary_hash = Helper.safe_decode_58(address_hash)
    address = Addresses.get(binary_hash)

    if is_nil(address) do
      conn
      |> put_flash(:info, "Not Found in DB!")
      |> redirect(to: home_path(conn, :index))
    else
      balances = Addresses.get_balances(binary_hash)
      neo_balance = Enum.find(balances, &(&1.asset == @neo_asset_hash))
      gas_balance = Enum.find(balances, &(&1.asset == @gas_asset_hash))

      token_balances =
        Enum.filter(balances, &(not (&1.asset in [@neo_asset_hash, @gas_asset_hash])))

      token_balances =
        Enum.map(token_balances, fn balance ->
          %{
            balance
            | name: Enum.reduce(balance.name, %{}, fn name, acc -> Map.merge(acc, name) end)
          }
        end)

      transactions = Addresses.get_transactions(binary_hash)
      graph_data = []

      render(
        conn,
        "address.html",
        address: %{
          hash: Base58.encode(address.hash),
          tx_count: 123
        },
        balance: %{
          neo: neo_balance.value,
          gas: gas_balance.value,
          tokens: token_balances
        },
        transactions: transactions,
        page: page,
        graph_data: graph_data
      )
    end
  end
end
