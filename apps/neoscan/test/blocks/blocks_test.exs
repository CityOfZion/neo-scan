defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Blocks

  describe "blocks" do
    alias Neoscan.Blocks.Block

    test "list_blocks/0 returns all blocks" do
      block = insert(:block)
      assert Blocks.list_blocks() == [block]
    end

    test "get_block!/1 returns the block with given id" do
      block = insert(:block)
      assert Blocks.get_block!(block.id) == block
    end

    test "create_block/1 with valid data creates a block" do
      block = insert(:block)
              |> IO.inspect()
      assert block.confirmations == 50
      assert String.contains?(block.hash, "hash")
      assert block.index == 5
      assert String.length(block.merkleroot) > 64
      assert String.length(block.nextblockhash) > 64
      assert String.length(block.nextconsensus) > 64
      assert String.contains?(block.nonce, "nonce")
      assert String.length(block.previousblockhash) > 64
      assert %{} = block.script
      assert block.size == 1526
      assert block.time == 15154813
      assert block.version == 2
    end

    test "update_block/2 with valid data updates the block" do
      block = insert(:block)
      assert {:ok, block} = Blocks.update_block(
               block,
               %{
                 confirmations: 57,
                 hash: "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 merkleroot: "b33f6f3dfead7ddpe999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 nextblockhash: "b33f6f3dfead7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 previousblockhash: "b33f6f3dfpad7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8"
               }
             )
      assert block.confirmations == 57
    end

    test "update_block/2 with invalid data returns error changeset" do
      block = insert(:block)
      assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, %{confirmations: nil})
      assert block == Blocks.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = insert(:block)
      assert %Block{} = Blocks.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    end

    test "change_block/1 returns a block changeset" do
      block = insert(:block)
      assert %Ecto.Changeset{} = Blocks.change_block(block)
    end
  end
end
