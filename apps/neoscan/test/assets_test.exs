defmodule Neoscan.AssetsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Assets

  test "get/1" do
    asset = insert(:asset)
    assert asset.transaction_hash == Assets.get(asset.transaction_hash).transaction_hash
  end

  test "paginate/1" do
    for _ <- 1..20, do: insert(:asset)
    assert 15 == Enum.count(Assets.paginate(1))
    assert 5 == Enum.count(Assets.paginate(2))
  end
end
