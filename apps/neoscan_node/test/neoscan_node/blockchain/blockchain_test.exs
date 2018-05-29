defmodule Neoscan.Blockchain.BlockchainTest do
  use ExUnit.Case

  alias NeoscanNode.Blockchain

  @node_url "http://seed1.cityofzion.io:8080"

  test "get_block_by_height/2" do
    assert {:ok, %{"index" => 0}} = Blockchain.get_block_by_height([@node_url], 0)
    assert {:ok, %{"index" => 1}} = Blockchain.get_block_by_height([@node_url], 1)
  end

  test "get_block_by_hash/2" do
    block_0_hash = "d42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf"
    block_1_hash = "d782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9"
    assert {:ok, %{"index" => 0}} = Blockchain.get_block_by_hash([@node_url], block_0_hash)
    assert {:ok, %{"index" => 1}} = Blockchain.get_block_by_hash([@node_url], block_1_hash)
  end

  test "get_current_height/1" do
    {:ok, height} = Blockchain.get_current_height([@node_url])
    assert 200 == height
  end

  test "get_transaction/2" do
    txid = "0x9e9526615ee7d460ed445c873c4af91bf7bfcc67e6e43feaf051b962a6df0a98"
    assert {:ok, %{"txid" => ^txid}} = Blockchain.get_transaction([@node_url], txid)
  end

  test "get_asset/2" do
    txid = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
    assert {:ok, %{"id" => ^txid}} = Blockchain.get_asset([@node_url], txid)
  end

  test "get_contract/2" do
    contract_hash = "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"

    assert {
             :ok,
             %{"author" => "Red Pulse", "description" => "RPX Sale", "hash" => ^contract_hash}
           } = Blockchain.get_contract([@node_url], contract_hash)
  end
end
