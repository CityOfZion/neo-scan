defmodule Neoscan.BlockchainTests  do
  use Neoscan.Web.ConnCase

  alias Neoscan.Blockchain

  test "receive current block height" do
    { :ok, result }  = Blockchain.get_current_height(%{:index => 0})
    assert is_number(result)
  end


  test "get block by height" do
    { :ok, count } = Blockchain.get_current_height(%{:index => 0})
    { :ok, %{"index" => result}} = Blockchain.get_block_by_height(%{:index => 0, :height => count-10})
    assert count-10 == result
  end


end
