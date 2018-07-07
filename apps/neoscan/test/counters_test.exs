defmodule Neoscan.CountersTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Counters

  test "_count_transactions/0" do
    for _ <- 1..18, do: insert(:block, tx_count: 3)
    assert 36 == Counters._count_transactions()
    assert 36 == Enum.at(Counters.count_transactions(), 1)
  end

  test "count_blocks/0" do
    for _ <- 1..18, do: insert(:block)
    assert 18 == Counters.count_blocks()
  end

  test "count_addresses/0" do
    for _ <- 1..18, do: insert(:address)
    assert 18 == Counters.count_addresses()
  end
end
