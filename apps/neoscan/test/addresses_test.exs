defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Addresses

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  @gas_asset_hash <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16, 132,
                    227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45, 231>>

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

  test "get_balance_history/1" do
    block_time0 = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 22)

    address_history =
      insert(:address_history, %{asset_hash: @neo_asset_hash, value: 2.0, block_time: block_time0})

    block_time = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 12)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      value: 3.0,
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @gas_asset_hash,
      value: 0.2130,
      block_time: block_time
    })

    address_history2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        asset_hash: @neo_asset_hash,
        value: -3.0
      })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      block_time: address_history2.block_time,
      value: 2.0
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      block_time: address_history2.block_time,
      value: 2.0
    })

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @gas_asset_hash,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    balances = Addresses.get_balance_history(address_history.address_hash)

    assert [
             %{assets: [%{"NEO" => 2.0}], time: _},
             %{assets: [%{"GAS" => 0.213}, %{"NEO" => 5.0}], time: _},
             %{assets: [%{"NEO" => 4.0}], time: _}
           ] = balances
  end
end
