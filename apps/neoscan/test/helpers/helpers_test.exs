defmodule Neoscan.Helpers.HelperTest do
  use Neoscan.DataCase

  alias Neoscan.Helpers

  test "populate_groups/2" do
    address_list = [{%{:address => "address1"}, nil}]

    assert [{{%{address: "address1"}, nil}, "vins"}] ==
             Helpers.populate_groups([{"address1", "vins"}], address_list)
  end

  test "map_vins/1" do
    assert [] == Helpers.map_vins(nil)
    assert [] == Helpers.map_vins([])
    assert ["address1"] == Helpers.map_vins([%{"address_hash" => "address1"}])
    assert ["address1"] == Helpers.map_vins([%{address_hash: "address1"}])
  end

  test "map_vouts/1" do
    assert [] == Helpers.map_vouts(nil)
    assert [] == Helpers.map_vouts([])
    assert ["address1"] == Helpers.map_vouts([%{"address" => "address1"}])
    assert ["address1"] == Helpers.map_vouts([%{address_hash: "address1"}])
  end

  # TODO: probably need to refactor the 3 following functions
  test "check_if_attrs_balance_exists/1" do
    assert Helpers.check_if_attrs_balance_exists(%{balance: :something})
    assert not Helpers.check_if_attrs_balance_exists(%{})
  end

  test "check_if_attrs_txids_exists/1" do
    assert Helpers.check_if_attrs_txids_exists(%{tx_ids: :something})
    assert not Helpers.check_if_attrs_txids_exists(%{})
  end

  test "check_if_attrs_claimed_exists/1" do
    assert Helpers.check_if_attrs_claimed_exists(%{claimed: :something})
    assert not Helpers.check_if_attrs_claimed_exists(%{})
  end

  test "substitute_if_updated/3" do
    assert {
             %{:address => "address1"},
             %{
               "hello" => "world"
             }
           } ==
             Helpers.substitute_if_updated(%{address: "address1"}, %{}, [
               {%{:address => "address1"}, %{"hello" => "world"}}
             ])

    assert {
             %{:address => "address2"},
             %{}
           } ==
             Helpers.substitute_if_updated(%{address: "address2"}, %{}, [
               {%{:address => "address1"}, %{"hello" => "world"}}
             ])
  end

  test "round_or_not/1" do
    assert 12.3 == Helpers.round_or_not(12.3)
    assert 12 == Helpers.round_or_not(12)
    assert 12.3 == Helpers.round_or_not("12.3")
  end

  test "contract?/1" do
    assert not Helpers.contract?(
             "1234567890123456789012345678901234567890123456789012345678901234"
           )

    assert Helpers.contract?("12")
  end

  test "apply_precision/3" do
    assert "0.000001234567" ==
             Helpers.apply_precision(1_234_567, "1234567890123456789012345678901234567890", 12)

    assert "1234567" == Helpers.apply_precision(1_234_567, "1", 12)
  end
end
