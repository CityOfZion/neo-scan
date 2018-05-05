defmodule Neoscan.Vouts.VoutsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Vouts
  alias Neoscan.Vouts.Vout
  import Mock

  test "create_vout/2" do
    with_mock Neoscan.ChainAssets, verify_asset: fn _, _ -> "jkasddsa89dassad" end do
      transaction = insert(:transaction)
      address = insert(:address)

      attrs = %{
        "address" => {address, nil},
        "value" => "23.4",
        "n" => 1,
        "asset" => "42382483jsddjsk"
      }

      assert %Vout{} = Vouts.create_vout(transaction, attrs)
    end
  end

  test "create_vouts/2" do
    transaction = insert(:transaction)
    insert(:address)
    vouts = []
    address_list = []

    assert {:ok, "all operations were succesfull"} ==
             Vouts.create_vouts(transaction, vouts, address_list)
  end
end
