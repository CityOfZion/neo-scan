defmodule Neoscan.CountersTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Counters
  alias Neoscan.Flush

  test "_count_transactions/0" do
    for _ <- 1..18, do: insert(:block, tx_count: 3)
    assert 36 == Counters._count_transactions()
    assert 36 == Enum.at(Counters.count_transactions(), 1)
  end

  test "count_blocks/0" do
    assert 0 == Counters.count_blocks()
    insert(:block_meta, %{id: 1, index: 18})
    assert 18 == Counters.count_blocks()
  end

  test "count_addresses/0" do
    for _ <- 1..18, do: insert(:address)
    Flush.all()
    assert 18 == Counters.count_addresses()
  end
end
