defmodule Neoscan.Claims.ClaimsTest do
  use Neoscan.DataCase

  alias Neoscan.Claims
  alias Neoscan.Claims.Claim

  test "change_claim/3" do
    valid_attrs = %{
      block_height: 123,
      amount: 12,
      asset: "232",
      time: 123,
      txids: ["322322"]
    }

    changeset = Claims.change_claim(%Claim{}, %{id: 124, address: "dsfj"}, valid_attrs)
    assert changeset.valid?
  end

  test "separate_txids_and_insert_claims/5" do
    address_list = [{%{address: "address2"}, %{"hello" => "world"}}]
    claims = [%{:txid => "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8"}]

    vouts = [
      %{
        "address" => "address2",
        "value" => 123,
        "asset" => "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8"
      }
    ]

    index = 12
    time = 1234

    assert [
             {
               %{address: "address2"},
               %{
                 :claimed => %{
                   amount: 123,
                   asset: "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                   block_height: 12,
                   time: 1234,
                   txids: ["b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8"]
                 },
                 "hello" => "world"
               }
             }
           ] == Claims.separate_txids_and_insert_claims(address_list, claims, vouts, index, time)
  end

  test "add_claim_if_claim/3" do
    assert [] == Claims.add_claim_if_claim([], nil, nil)
    assert %Ecto.Multi{} = Claims.add_claim_if_claim(Ecto.Multi.new(), "124242_claim", %Claim{})
  end
end
