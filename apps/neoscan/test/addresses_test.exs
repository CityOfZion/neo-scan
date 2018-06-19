defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Addresses

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  test "get_balances/1" do
    address_history = insert(:address_history, %{asset_hash: <<1, 2, 3>>, value: 1.0})

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      value: 2.0
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      value: 3.0
    })

    insert(:asset, %{transaction_hash: @neo_asset_hash, name: [%{"en" => "NEO"}]})
    balances = Addresses.get_balances(address_history.address_hash)
    assert 1 == Enum.count(balances)
  end

  test "get_transactions/1" do
    transaction1 = insert(:transaction)
    transaction2 = insert(:transaction)
    address_history = insert(:address_history, %{transaction_hash: transaction1.hash})

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      transaction_hash: transaction2.hash
    })

    transactions = Addresses.get_transactions(address_history.address_hash, 1)
    assert 2 == Enum.count(transactions)
  end
end
