defmodule Neoscan.Vouts.VoutsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Vouts
  alias Neoscan.Vouts.Vout

  test "create_vout/2" do
    transaction = insert(:transaction)
    address = insert(:address)

    attrs = %{
      "address" => {address, nil},
      "value" => "23.4",
      "n" => 1,
      "asset" =>
        <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144, 175, 133,
          96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>
    }

    assert %Vout{} = Vouts.create_vout(transaction, attrs)
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
