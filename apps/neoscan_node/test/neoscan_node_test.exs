defmodule NeoscanNodeTest do
  use ExUnit.Case

  test "get_height/0" do
    {:ok, height} = NeoscanNode.get_height()
    assert is_number(height)
  end

  test "get_data/0" do
    [{url, height} | _] = NeoscanNode.get_data()
    assert is_bitstring(url) and is_number(height)
  end

  test "get_block_with_transfers/1" do
    block = NeoscanNode.get_block_with_transfers(1_444_843)

    transaction =
      Enum.find(
        block.tx,
        &(&1.hash ==
            <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254, 241, 118,
              125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>)
      )

    assert 3 == Enum.count(transaction.transfers)
  end
end
