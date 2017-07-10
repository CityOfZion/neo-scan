defmodule Neoscan.BlockchainTests  do
  use Neoscan.Web.ConnCase

  alias Neoscan.Blockchain

  test "receive current block height" do
    { nil , result } = Blockchain.get_current_height( nil, %{:index => 0})
    assert is_number(result)
  end


  test "get block by height" do
    { nil, count } = Blockchain.get_current_height( nil, %{:index => 0})
    { nil , %{"index" => result} } = Blockchain.get_block_by_height( nil, %{:index => 0, :height => count-10})
    assert count-10 == result
  end


end
