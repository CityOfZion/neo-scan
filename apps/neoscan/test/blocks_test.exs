defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Blocks

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
end
