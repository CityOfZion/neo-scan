defmodule Neoscan.TxAbstractsTest do
  use Neoscan.DataCase
  # import Neoscan.Factory
  alias Neoscan.TxAbstracts

  test "create_abstracts_from_tx/1" do
    asset = "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"

    transaction = %{
      "vin" => [
        %{address_hash: "abcdef", value: 12, asset: asset},
        %{address_hash: "jklmn", value: 32, asset: asset}
      ],
      "vout" => [%{"address" => "abcdef", "value" => 44, "asset" => asset}],
      "txid" => "sfsdds",
      "block_height" => 23,
      "time" => 1233
    }

    assert :ok == TxAbstracts.create_abstracts_from_tx(transaction)
  end

  test "get_amount_for_address/2" do
    list = [
      %{"address" => "abcdef", "value" => 3},
      %{"address" => "jklmn", "value" => 4},
      %{"address" => "abcdef", "value" => 1}
    ]

    assert 4 == TxAbstracts.get_amount_for_address("abcdef", list)
  end

  test "build_list_for_multiple_vins/1" do
    asset = "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"

    transaction = %{
      "vin" => [%{address_hash: "abcdef", value: 12, asset: asset}],
      "vout" => [%{"address" => "abcdef", "value" => 12, "asset" => asset}],
      "txid" => "sfsdds",
      "block_height" => 23,
      "time" => 1233
    }

    assert [
             %{
               address_from: "abcdef",
               address_to: "sfsdds",
               amount: 12,
               asset: "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
               block_height: 23,
               time: 1233,
               txid: "sfsdds"
             },
             %{
               address_from: "sfsdds",
               address_to: "abcdef",
               amount: 12,
               asset: "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
               block_height: 23,
               time: 1233,
               txid: "sfsdds"
             }
           ] == TxAbstracts.build_list_for_multiple_vins(transaction)
  end
end
