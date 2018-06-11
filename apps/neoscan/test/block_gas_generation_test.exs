defmodule Neoscan.BlockGasGenerationTest do
  use Neoscan.DataCase
  alias Neoscan.BlockGasGeneration

  test "get_amount_generate_in_block/1" do
    assert is_nil(BlockGasGeneration.get_amount_generate_in_block(nil))
    assert 8.0 == BlockGasGeneration.get_amount_generate_in_block(0)
    assert 7.0 == BlockGasGeneration.get_amount_generate_in_block(2_400_000)
  end
end
