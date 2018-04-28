defmodule Neoscan.BalanceHistories.BalanceHistoriesTest do
  use Neoscan.DataCase, async: true

  alias Neoscan.BalanceHistories
  alias Neoscan.BalanceHistories.History

  test "change_history/3" do
    valid_attrs = %{
      block_height: 123,
      time: 0,
      txid: "239832"
    }

    BalanceHistories.change_history(%History{}, %{id: 124, address: "dsfj"}, valid_attrs)
  end
end
