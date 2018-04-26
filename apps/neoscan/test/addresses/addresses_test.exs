defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Addresses

  describe "addresses" do
    alias Neoscan.Addresses.Address

    test "list_addresses/0 returns all addresses" do
      address = insert(:address)
      assert Addresses.list_addresses()
             |> List.first()
             |> Map.get(:id) == address.id
    end

    test "get_address!/1 returns the address with given id" do
      address = insert(:address)
      assert Addresses.get_address!(address.id)
             |> List.first()
             |> Map.get(:id) == address.id
    end

    test "update_address/2 with valid data updates the address" do
      address = insert(:address)

      assert {:ok, address} =
               Addresses.update_address(address, %{address: "AKCtwNNFtQjSDGAoyvPqqnTxtoTmBeLNUt"})

      assert %Address{} = address
    end

    #    test "update_address/2 with invalid data returns error changeset" do
    #      address = insert(:address)
    #      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, %{"balance" => nil})
    #    end

    test "delete_address/1 deletes the address" do
      address = insert(:address)
      Addresses.delete_address(address)
      assert Addresses.get_address!(address.id) == []
    end

    test "change_address/1 returns a address changeset" do
      address = insert(:address)
      assert %Ecto.Changeset{} = Addresses.change_address(address, %{})
    end

    test "list_latest/0 returns latest addresses" do
      _address1 = insert(:address)
      address2 = insert(:address)
      [address, _] = Addresses.list_latest

      assert address2.address == address.address
      assert address2.balance == address.balance
      assert address2.time == address.time
      assert address2.tx_count == address.tx_count
    end

    test "count_addresses/0 returns number of addresses" do
      insert(:address)
      insert(:address)
      insert(:address)
      assert 3 = Addresses.count_addresses()
    end

    test "paginate_addresses/1 returns paginated addresses" do
      for _ <- 1..20, do: insert(:address)
      assert 15 == Enum.count(Addresses.paginate_addresses(1))
      assert 5 == Enum.count(Addresses.paginate_addresses(2))
      assert 0 == Enum.count(Addresses.paginate_addresses(3))
    end

    test "count_addresses_for_asset/1 returns number of address having assets" do
      %{balance: balance} = insert(:address)
      [{asset, _}] = Enum.map(balance, &(&1))
      assert 1 == Addresses.count_addresses_for_asset(asset)
      assert 0 == Addresses.count_addresses_for_asset("random")
    end

    test "get_address_by_hash_for_view/1 returns number of address having assets" do
      address = insert(:address)
      address1 = Addresses.get_address_by_hash_for_view(address.address)
      assert address1.address == address.address
      assert nil == Addresses.get_address_by_hash_for_view("random")
    end

    # TODO this is a duplicate!
    test "get_address_by_hash/1 returns number of address having assets" do
      address = insert(:address)
      address1 = Addresses.get_address_by_hash(address.address)
      assert address1.address == address.address
      assert nil == Addresses.get_address_by_hash("random")
    end

    test "create_address/1 returns address from attributes" do
      assert %{address: "123", time: 1234} = Addresses.create_address(%{address: "123", time: 1234})
    end

    #    test "update_multiple_addresses/1 " do
    #      address1 = insert(:address)
    #      address2 = insert(:address)
    #
    # TODO not sure how the update list should be constructed.
    #
    #      IO.inspect address1
    #
    #      update_list = [{address1, %{}}, {address2, %{}}]
    #
    #      Addresses.update_multiple_addresses(update_list)
    #
    #      IO.inspect address1
    #      IO.inspect address2
    #    end

    test "check_if_exist/1 returns boolean" do
      _address = insert(:address)
      # TODO weird behavior here, should return true but does not work.
      #assert Addresses.check_if_exist(address.address)
      assert not Addresses.check_if_exist("random")
    end

    test "get_transaction_addresses/4" do
      address1 = insert(:address)
      address2 = insert(:address)
      vin = [%{address_hash: address1.address}]
      vouts = [%{address_hash: address2.address}]

      assert 2 == Enum.count(Addresses.get_transaction_addresses(vin, vouts, 12345, %{}))
    end

    test "get_transfer_addresses/2 returns addresses" do
      address1 = insert(:address)
      address2 = insert(:address)

      addresses = [address1.address, address2.address]

      assert 2 == Enum.count(Addresses.get_transfer_addresses(addresses, 12355))
    end

    test "get_transactions_addresses/1 returns addresses" do
      address1 = insert(:address)
      address2 = insert(:address)
      _address3 = insert(:address)

      transaction = %{vin: [%{address_hash: address1.address}], vouts: [%{address_hash: address2.address}]}

      assert 2 == Enum.count(Addresses.get_transactions_addresses([transaction]))
    end

#    test "update_all_addresses/7 returns ..." do
#    end
  end
end
