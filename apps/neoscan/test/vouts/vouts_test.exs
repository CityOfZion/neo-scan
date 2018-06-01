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
      "asset" => "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
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
