defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Blocks
  alias Neoscan.BlocksCache

  test "get/1" do
    block = insert(:block)
    assert block.hash == Blocks.get(block.index).hash
    assert block.index == Blocks.get(block.hash).index
    assert is_nil(Blocks.get(block.index + 1))
  end

  test "paginate/1" do
    for _ <- 1..20, do: insert(:block)
    assert 15 == Enum.count(Blocks.paginate(1))
    assert 5 == Enum.count(Blocks.paginate(2))
  end

  test "get_missing_block_indexes/0" do
    insert(:block, %{index: 0})
    insert(:block, %{index: 2})
    insert(:block, %{index: 4})
    assert [1, 3] == Enum.sort(Blocks.get_missing_block_indexes())
  end

  test "get_max_index/0" do
    assert -1 == Blocks.get_max_index()
    insert(:block, %{index: 0})
    insert(:block, %{index: 2})
    insert(:block, %{index: 4})
    assert 4 == Blocks.get_max_index()
  end

  test "get_sys_fees_in_range/2" do
    assert Decimal.equal?("0.0", BlocksCache.get_sys_fees_in_range(12, 15))
    insert(:block, %{index: 10, total_sys_fee: Decimal.new("1.0")})
    insert(:block, %{index: 11, total_sys_fee: Decimal.new("1.0")})
    insert(:block, %{index: 12, total_sys_fee: Decimal.new("2.0")})
    insert(:block, %{index: 13, total_sys_fee: Decimal.new("2.0")})
    insert(:block, %{index: 14, total_sys_fee: Decimal.new("3.0")})
    insert(:block, %{index: 15, total_sys_fee: Decimal.new("4.0")})
    insert(:block, %{index: 16, total_sys_fee: Decimal.new("5.0")})
    assert Decimal.equal?("11.0", BlocksCache.get_sys_fees_in_range(12, 15))
    assert Decimal.equal?("17.0", BlocksCache.get_sys_fees_in_range(11, 16))

    assert Decimal.equal?("17.0", BlocksCache.get_sys_fees_in_range(11, 19))
  end
end
