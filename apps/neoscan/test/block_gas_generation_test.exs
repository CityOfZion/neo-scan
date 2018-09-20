defmodule Neoscan.BlockGasGenerationTest do
  use Neoscan.DataCase
  alias Neoscan.BlockGasGeneration

  test "get_amount_generate_in_block/1" do
    assert is_nil(BlockGasGeneration.get_amount_generate_in_block(nil))
    assert Decimal.equal?("8.0", BlockGasGeneration.get_amount_generate_in_block(0))
    assert Decimal.equal?("7.0", BlockGasGeneration.get_amount_generate_in_block(2_400_000))
    assert Decimal.equal?("7.0", BlockGasGeneration.get_amount_generate_in_block(2_000_000))
    assert Decimal.equal?("0.0", BlockGasGeneration.get_amount_generate_in_block(48_000_000))
    BlockGasGeneration.get_amount_generate_in_block(44_000_000)
  end

  test "get_range_amount/2" do
    assert 62_909_916 == BlockGasGeneration.get_range_amount(101_232, 11_239_923)
  end
end
