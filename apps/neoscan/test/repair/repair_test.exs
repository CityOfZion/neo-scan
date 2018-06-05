defmodule Neoscan.Repair.RepairTest do
  use Neoscan.DataCase

  alias Neoscan.Repair

  test "get_transaction/1" do
    assert {:ok,
            %{
              "blockhash" =>
                <<22, 112, 66, 124, 168, 57, 171, 133, 90, 50, 105, 74, 128, 61, 193, 53, 120, 64,
                  236, 177, 165, 255, 194, 172, 55, 49, 176, 225, 41, 179, 185, 86>>
            }} =
             Repair.get_transaction(
               "9f3316d2eaa4c5cdd8cfbd3252be14efb8e9dcd76d3115517c45f85946db41b2"
             )
  end

  test "get_and_add_missing_block/1" do
    assert :ok ==
             Repair.get_and_add_missing_block(
               "87ba13e7af11d599364f7ee0e59970e7e84611bbdbe27e4fccee8fb7ec6aba28"
             )
  end

  test "get_and_add_missing_block_from_height/1" do
    assert :ok == Repair.get_and_add_missing_block_from_height(123)
  end
end
