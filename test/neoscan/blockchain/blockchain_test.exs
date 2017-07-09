defmodule Neoscan.BlockchainTests  do
  use Neoscan.Web.ConnCase

  alias Neoscan.Blockchain

  test "receive current block height" do
    assert {:ok , _ } = Blockchain.get_current_height( nil, %{:index => 0})
  end

end
