defmodule Neoscan.BalanceHistories.BalanceHistoriesTest do
  use Neoscan.DataCase

  alias Neoscan.BalanceHistories
  alias Neoscan.BalanceHistories.History
  import Neoscan.Factory

  test "change_history/3" do
    valid_attrs = %{
      block_height: 123,
      time: 0,
      txid: "239832"
    }

    BalanceHistories.change_history(%History{}, %{id: 124, address: "dsfj"}, valid_attrs)
  end

  test "add_tx_id/4" do
    attrs = %{
      txid: "1234",
      balance: 1235,
      block_height: 0,
      time: 1234,
      tx_ids: nil
    }

    assert %{
             balance: 1235,
             block_height: 0,
             time: 1234,
             tx_ids: %{
               balance: 1235,
               block_height: 45,
               time: 123,
               txid: "2345"
             },
             txid: "1234"
           } == BalanceHistories.add_tx_id(attrs, "2345", 45, 123)
  end

  test "count_hist_for_address/1" do
    history = insert(:history)
    assert 1 == BalanceHistories.count_hist_for_address(history.address_hash)
  end

  test "get_graph_data_for_address/1" do
    history =
      insert(:history, %{
        balance: %{
          "assethash" => %{
            "amount" => 456,
            "time" => 123
          }
        }
      })

    assert [%{assets: [%{"Asset not Found" => 456}], time: 123}] ==
             BalanceHistories.get_graph_data_for_address(history.address_hash)
  end
end
