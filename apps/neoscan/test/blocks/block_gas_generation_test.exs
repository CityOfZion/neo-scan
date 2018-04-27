defmodule Neoscan.Blocks.BlockGasGenerationTest do
  use Neoscan.DataCase

  alias Neoscan.BlockGasGeneration

  test "get_amount_generate_in_block/1" do
    assert 8 == BlockGasGeneration.get_amount_generate_in_block(0)
  end
end
