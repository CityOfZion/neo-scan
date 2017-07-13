defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase

  alias Neoscan.Blocks

  describe "blocks" do
    alias Neoscan.Blocks.Block

    @valid_attrs %{confirmations: 42, hash: "some hash", index: 42, merkleroot: "some merkleroot", nextblockhash: "some nextblockhash", nextconsensus: "some nextconsensus", nonce: "some nonce", previousblockhash: "some previousblockhash", script: %{}, size: 42, time: 42, version: 42}
    @update_attrs %{confirmations: 43, hash: "some updated hash", index: 43, merkleroot: "some updated merkleroot", nextblockhash: "some updated nextblockhash", nextconsensus: "some updated nextconsensus", nonce: "some updated nonce", previousblockhash: "some updated previousblockhash", script: %{}, size: 43, time: 43, version: 43}
    @invalid_attrs %{confirmations: nil, hash: nil, index: nil, merkleroot: nil, nextblockhash: nil, nextconsensus: nil, nonce: nil, previousblockhash: nil, script: nil, size: nil, time: nil, version: nil}

    def block_fixture(attrs \\ %{}) do
      {:ok, block} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blocks.create_block()

      block
    end

    test "list_blocks/0 returns all blocks" do
      block = block_fixture()
      assert Blocks.list_blocks() == [block]
    end

    test "get_block!/1 returns the block with given id" do
      block = block_fixture()
      assert Blocks.get_block!(block.id) == block
    end

    test "create_block/1 with valid data creates a block" do
      assert {:ok, %Block{} = block} = Blocks.create_block(@valid_attrs)
      assert block.confirmations == 42
      assert block.hash == "some hash"
      assert block.index == 42
      assert block.merkleroot == "some merkleroot"
      assert block.nextblockhash == "some nextblockhash"
      assert block.nextconsensus == "some nextconsensus"
      assert block.nonce == "some nonce"
      assert block.previousblockhash == "some previousblockhash"
      assert block.script == %{}
      assert block.size == 42
      assert block.time == 42
      assert block.version == 42
    end

    test "create_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blocks.create_block(@invalid_attrs)
    end

    test "update_block/2 with valid data updates the block" do
      block = block_fixture()
      assert {:ok, block} = Blocks.update_block(block, @update_attrs)
      assert %Block{} = block
      assert block.confirmations == 43
      assert block.hash == "some updated hash"
      assert block.index == 43
      assert block.merkleroot == "some updated merkleroot"
      assert block.nextblockhash == "some updated nextblockhash"
      assert block.nextconsensus == "some updated nextconsensus"
      assert block.nonce == "some updated nonce"
      assert block.previousblockhash == "some updated previousblockhash"
      assert block.script == %{}
      assert block.size == 43
      assert block.time == 43
      assert block.version == 43
    end

    test "update_block/2 with invalid data returns error changeset" do
      block = block_fixture()
      assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, @invalid_attrs)
      assert block == Blocks.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = block_fixture()
      assert {:ok, %Block{}} = Blocks.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    end

    test "change_block/1 returns a block changeset" do
      block = block_fixture()
      assert %Ecto.Changeset{} = Blocks.change_block(block)
    end
  end
end
