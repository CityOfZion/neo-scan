defmodule Neoscan.Repair.RepairTest do
  use Neoscan.DataCase

  alias Neoscan.Repair

  test "get_transaction/1" do
    assert {:ok,
            %{"blockhash" => "0x1670427ca839ab855a32694a803dc1357840ecb1a5ffc2ac3731b0e129b3b956"}} =
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
