defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Addresses

  describe "addresses" do
    alias Neoscan.Addresses.Address

    test "list_addresses/0 returns all addresses" do
      address = insert(:address)
      assert Addresses.list_addresses() |> List.first |> Map.get(:id) == address.id
    end

    test "get_address!/1 returns the address with given id" do
      address = insert(:address)
      assert Addresses.get_address!(address.id) |> List.first |> Map.get(:id) == address.id
    end

    test "update_address/2 with valid data updates the address" do
      address = insert(:address)
      assert {:ok, address} = Addresses.update_address(address, %{address: "AKCtwNNFtQjSDGAoyvPqqnTxtoTmBeLNUt"})
      assert %Address{} = address
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = insert(:address)
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, %{"balance" => nil})
    end

    test "delete_address/1 deletes the address" do
      address = insert(:address)
      Addresses.delete_address(address)
      assert Addresses.get_address!(address.id) == []
    end

    test "change_address/1 returns a address changeset" do
      address = insert(:address)
      assert %Ecto.Changeset{} = Addresses.change_address(address, %{})
    end
  end
end
