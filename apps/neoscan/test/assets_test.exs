defmodule Neoscan.AssetsTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Assets

  test "get_all/0" do
    insert(:asset)
    insert(:asset)
    assert 2 == Enum.count(Assets.get_all())
  end
end
