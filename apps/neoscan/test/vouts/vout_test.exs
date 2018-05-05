defmodule Neoscan.Vouts.VoutTest do
  use Neoscan.DataCase

  alias Neoscan.Vouts.Vout
  import Mock

  describe "schema" do
    test "empty schema has default txid is nil" do
      vout = %Vout{}
      assert is_nil(vout.txid)
    end
  end

  describe "changeset/2" do
    test "returns valid changeset" do
      with_mock Neoscan.ChainAssets, verify_asset: fn _, _ -> "jkasddsa89dassad" end do
        vout = %{id: 12, txid: "1234", time: 1234, block_height: 124}

        attrs = %{
          "address" => {%{address: "address", id: 1234}, nil},
          "value" => "23.4",
          "n" => 1,
          "asset" => "42382483jsddjsk"
        }

        changeset = Vout.changeset(vout, attrs)

        assert changeset.valid?
      end
    end
  end

  test "update_changeset/2" do
    with_mock Neoscan.ChainAssets, verify_asset: fn _, _ -> "jkasddsa89dassad" end do
      vout = %{id: 12, txid: "1234", time: 1234, block_height: 124}

      attrs = %{
        "address" => {%{address: "address", id: 1234}, nil},
        "value" => "23.4",
        "n" => 1,
        "asset" => "42382483jsddjsk"
      }

      changeset = Vout.changeset(vout, attrs)
      assert 2133 == Vout.update_changeset(changeset, %{:end_height => 2133}).changes.end_height
      assert Vout.update_changeset(changeset, %{:claimed => true}).changes.claimed
    end
  end
end
