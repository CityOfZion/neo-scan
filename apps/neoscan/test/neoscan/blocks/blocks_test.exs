defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase

  alias Neoscan.Blocks

  describe "blocks" do
    alias Neoscan.Blocks.Block

    @valid_attrs %{hash: "some hash", height: "some height", merkleroot: "some merkleroot", nextminer: "some nextminer", nonce: "some nonce", previousblockhash: "some previousblockhash", script: %{}, size: "some size", time: "some time", version: "some version"}
    @update_attrs %{hash: "some updated hash", height: "some updated height", merkleroot: "some updated merkleroot", nextminer: "some updated nextminer", nonce: "some updated nonce", previousblockhash: "some updated previousblockhash", script: %{}, size: "some updated size", time: "some updated time", version: "some updated version"}
    @invalid_attrs %{hash: nil, height: nil, merkleroot: nil, nextminer: nil, nonce: nil, previousblockhash: nil, script: nil, size: nil, time: nil, version: nil}

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
      assert block.hash == "some hash"
      assert block.height == "some height"
      assert block.merkleroot == "some merkleroot"
      assert block.nextminer == "some nextminer"
      assert block.nonce == "some nonce"
      assert block.previousblockhash == "some previousblockhash"
      assert block.script == %{}
      assert block.size == "some size"
      assert block.time == "some time"
      assert block.version == "some version"
    end

    test "create_block/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blocks.create_block(@invalid_attrs)
    end

    test "update_block/2 with valid data updates the block" do
      block = block_fixture()
      assert {:ok, block} = Blocks.update_block(block, @update_attrs)
      assert %Block{} = block
      assert block.hash == "some updated hash"
      assert block.height == "some updated height"
      assert block.merkleroot == "some updated merkleroot"
      assert block.nextminer == "some updated nextminer"
      assert block.nonce == "some updated nonce"
      assert block.previousblockhash == "some updated previousblockhash"
      assert block.script == %{}
      assert block.size == "some updated size"
      assert block.time == "some updated time"
      assert block.version == "some updated version"
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
