defmodule Neoscan.BlockchainTests  do
  use Neoscan.Web.ConnCase

  alias Neoscan.Blockchain

  test "receive current block height" do
    { :ok, result }  = Blockchain.get_current_height(0)
    assert is_integer(result)
  end


  test "get block by height" do
    { :ok, count } = Blockchain.get_current_height(0)
    { :ok, %{"index" => result}} = Blockchain.get_block_by_height( 0, count-10)
    assert count-10 == result
  end


end
