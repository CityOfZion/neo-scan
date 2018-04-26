defmodule Neoscan.Api.ApiTest do
  use Neoscan.DataCase, async: true
  import Neoscan.Factory
  alias Neoscan.Api

  test "get_balance/1" do
    address = insert(:address)

    assert not is_nil(Api.get_balance(address.address).balance)
    assert is_nil(Api.get_balance("notexisting").balance)
  end

  test "get_unclaimed/1" do
    address = insert(:address)

    assert %{address: address.address, unclaimed: 0} == Api.get_unclaimed(address.address)
    assert %{address: "not found", unclaimed: 0} == Api.get_unclaimed("notexisting")
  end

  test "get_claimed/1" do
    address = insert(:address)
    expected_claim = [%{txids: List.first(address.claimed).txids}]
    assert %{address: address.address, claimed: expected_claim} == Api.get_claimed(address.address)
    assert %{address: "not found", claimed: nil} == Api.get_claimed("notexisting")
  end

  test "get_claimable/1" do
    address = insert(:address)
    assert %{address: address.address, claimable: [], unclaimed: 0} == Api.get_claimable(address.address)
    assert %{address: "not found", claimable: nil} == Api.get_claimable("notexisting")
  end

  test "get_address/1" do
    address = insert(:address)
    assert %{address: "not found", balance: nil, txids: nil, claimed: nil} == Api.get_address("notexisting")
    assert 0 == Api.get_address(address.address).unclaimed
  end

  test "get_address_neon/1" do
    _address = insert(:address)
    assert %{address: "not found", balance: nil, txids: nil, claimed: nil} == Api.get_address_neon("notexisting")
    #Api.get_address_neon(address.address)
  end
end
