defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase

  alias Neoscan.Blocks

  describe "blocks" do
    alias Neoscan.Blocks.Block

    @valid_attrs %{confirmations: 1, hash: "some hash", height: 1, merkleroot: "some merkleroot", nextblockhash: "some nextblockhash", nextconsensus: "some nextconsensus", nonce: "some nonce", previousblockhash: "some previousblockhash", script: %{}, size: 656, time: 65656, version: 5165}
    @update_attrs %{confirmations: 2, hash: "some updated hash", height: 2, merkleroot: "some updated merkleroot", nextblockhash: "some nextblockhash", nextconsensus: "some nextconsensus", nonce: "some updated nonce", previousblockhash: "some updated previousblockhash", script: %{}, size: 5657, time: 656565, version: 6251}
    @invalid_attrs %{confirmations: nil, hash: nil, height: nil, merkleroot: nil, nextblockhash: nil, nextconsensus: nil, nonce: nil, previousblockhash: nil, script: nil, size: nil, time: nil, version: nil}

    def block_fixture(attrs \\ %{}) do
      {:ok, block} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blocks.create_block()

      block
    end

    # test "list_blocks/0 returns all blocks" do
    #   block = block_fixture()
    #   assert Blocks.list_blocks() == [block]
    # end
    #
    # test "get_block!/1 returns the block with given id" do
    #   block = block_fixture()
    #   assert Blocks.get_block!(block.id) == block
    # end
    #
    # test "create_block/1 with valid data creates a block" do
    #   assert {:ok, %Block{} = block} = Blocks.create_block(@valid_attrs)
    #   assert block.hash == "some hash"
    #   assert block.height == 1
    #   assert block.merkleroot == "some merkleroot"
    #   assert block.nextblockhash == "some nextblockhash"
    #   assert block.nextconsensus == "some nextconsensus"
    #   assert block.nonce == "some nonce"
    #   assert block.previousblockhash == "some previousblockhash"
    #   assert block.script == %{}
    #   assert block.size == 656
    #   assert block.time == 65656
    #   assert block.version == 5165
    # end
    #
    # test "create_block/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Blocks.create_block(@invalid_attrs)
    # end
    #
    # test "update_block/2 with valid data updates the block" do
    #   block = block_fixture()
    #   assert {:ok, block} = Blocks.update_block(block, @update_attrs)
    #   assert %Block{} = block
    #   assert block.hash == "some updated hash"
    #   assert block.height == 2
    #   assert block.merkleroot == "some updated merkleroot"
    #   assert block.nextblockhash == "some updated nextblockhash"
    #   assert block.nonce == "some updated nonce"
    #   assert block.previousblockhash == "some updated previousblockhash"
    #   assert block.script == %{}
    #   assert block.size == 5657
    #   assert block.time == 656565
    #   assert block.version == 6251
    # end
    #
    # test "update_block/2 with invalid data returns error changeset" do
    #   block = block_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, @invalid_attrs)
    #   assert block == Blocks.get_block!(block.id)
    # end
    #
    # test "delete_block/1 deletes the block" do
    #   block = block_fixture()
    #   assert {:ok, %Block{}} = Blocks.delete_block(block)
    #   assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    # end
    #
    # test "change_block/1 returns a block changeset" do
    #   block = block_fixture()
    #   assert %Ecto.Changeset{} = Blocks.change_block(block)
    # end
  end
end
