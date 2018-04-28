defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Blocks

  describe "blocks" do
    alias Neoscan.Blocks.Block

    test "home_blocks/0" do
      block = insert(:block)
      [block1] = Blocks.home_blocks()
      assert block.hash == block1.hash
    end

    test "paginate_blocks/1" do
      for _ <- 1..20, do: insert(:block)
      assert 15 == Enum.count(Blocks.paginate_blocks(1))
      assert 5 == Enum.count(Blocks.paginate_blocks(2))
      assert 0 == Enum.count(Blocks.paginate_blocks(3))
    end

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
      assert block.confirmations == 50
      assert String.contains?(block.hash, "hash")
      assert String.length(block.merkleroot) > 64
      assert String.length(block.nextblockhash) > 64
      assert String.length(block.nextconsensus) > 64
      assert String.contains?(block.nonce, "nonce")
      assert String.length(block.previousblockhash) > 64
      assert %{} = block.script
      assert block.size == 1526
      assert block.time == 15_154_813
      assert block.version == 2
    end

    test "update_block/2 with valid data updates the block" do
      block = insert(:block)

      assert {:ok, block} =
               Blocks.update_block(block, %{
                 "confirmations" => 57,
                 "hash" => "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "merkleroot" =>
                   "b33f6f3dfead7ddpe999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "nextblockhash" =>
                   "b33f6f3dfead7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "previousblockhash" =>
                   "b33f6f3dfpad7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "index" => 1
               })

      assert block.confirmations == 57
    end

    test "update_block/2 with invalid data returns error changeset" do
      block = insert(:block)
      assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, %{"confirmations" => nil})
      assert block == Blocks.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = insert(:block)
      assert %Block{} = Blocks.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    end
  end
end
