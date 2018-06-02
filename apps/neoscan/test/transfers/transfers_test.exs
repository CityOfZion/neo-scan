defmodule Neoscan.TransfersTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Transfers

  test "home_transfers/0" do
    insert(:transfer)
    insert(:transfer)
    assert 2 == length(Transfers.home_transfers())
  end

  test "paginate_transfers/1" do
    for _ <- 1..18, do: insert(:transfer)
    assert 15 == length(Transfers.paginate_transfers(1).entries)
    assert 3 == length(Transfers.paginate_transfers(2).entries)
  end

  test "paginate_address_transfers/2" do
    for _ <- 1..3, do: insert(:transfer, %{address_to: "abcdef"})
    for _ <- 1..20, do: insert(:transfer, %{address_from: "abcdef"})
    for _ <- 1..5, do: insert(:transfer)
    assert 15 == length(Transfers.paginate_address_transfers("abcdef", 1).entries)
    assert 8 == length(Transfers.paginate_address_transfers("abcdef", 2).entries)
  end

  test "get_transaction_transfers/1" do
    insert(:transfer, %{txid: "abcdef"})
    insert(:transfer, %{txid: "abcdef"})
    assert 2 == length(Transfers.get_transaction_transfers("abcdef"))
  end

  test "check_if_transfer_exist/1" do
    insert(:transfer, %{check_hash: "abcdef"})
    assert Transfers.check_if_transfer_exist("abcdef")
    assert not Transfers.check_if_transfer_exist("ijkl")
  end
end
