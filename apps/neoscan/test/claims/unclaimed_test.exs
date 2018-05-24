defmodule Neoscan.Claims.UnclaimedTest do
  use Neoscan.DataCase

  import Neoscan.Factory

  alias Neoscan.Claims.Unclaimed
  # alias Neoscan.Blocks.BlocksCache
  @asset "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"

  test "calculate_bonus/0" do
    # erase cache for consistency in results
    :ets.insert(Neoscan.Blocks.BlocksCache, {:min, nil})
    :ets.insert(Neoscan.Blocks.BlocksCache, {:max, nil})

    for x <- 1..75, do: insert(:block, %{index: x, total_sys_fee: x})

    address =
      insert(:address, %{
        vouts: [insert(:vout, %{asset: @asset, start_height: 25, end_height: 100})]
      })

    assert 0.0014750000000000002 == Unclaimed.calculate_bonus(address.id)
    assert [min: 25] == :ets.lookup(Neoscan.Blocks.BlocksCache, :min)
    assert [max: 75] == :ets.lookup(Neoscan.Blocks.BlocksCache, :max)

    for x <- 76..100, do: insert(:block, %{index: x, total_sys_fee: x})

    address =
      insert(:address, %{
        vouts: [insert(:vout, %{asset: @asset, start_height: 1, end_height: 100})]
      })

    assert 0.0028710000000000003 == Unclaimed.calculate_bonus(address.id)
    assert [min: 1] == :ets.lookup(Neoscan.Blocks.BlocksCache, :min)
    assert [max: 100] == :ets.lookup(Neoscan.Blocks.BlocksCache, :max)
  end
end
