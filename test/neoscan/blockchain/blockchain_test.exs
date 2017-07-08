defmodule Neoscan.BlockchainTests  do
  use Neoscan.Web.ConnCase
  use HTTPoison.Base

  alias Neoscan.Blockchain

  test "receive current block height" do
    # data = Poison.encode!(%{
    #   "jsonrpc" => "2.0",
    #   "method" => "getblockcount",
    #   "params" => [0],
    #   "id" => 5
    #   })
    # headers = %{"Content-Type" => "application/json"}
    assert {:ok , _ } = Blockchain.get_current_height( nil, %{:index => 0})
  end

end
