defmodule Neoscan.Stats.StatsTest do
  use Neoscan.DataCase

  alias Neoscan.Stats
  alias Neoscan.Stats.Counter

  test "initialize_counter/0" do
    assert %Counter{} = Stats.initialize_counter()
  end

  test "get_counter/0" do
    assert %Counter{} = Stats.get_counter()
  end

  test "create_if_doesnt_exists/1" do
    assert %Counter{} = Stats.create_if_doesnt_exists(nil)
  end

  test "add_block_to_table/0" do
    counter1 = Stats.get_counter()
    Stats.add_block_to_table()
    counter2 = Stats.get_counter()
    assert counter1.total_blocks + 1 == counter2.total_blocks
  end

  test "add_transaction_to_table/1" do
    counter1 = Stats.get_counter()
    Stats.add_transaction_to_table(%{type: "InvocationTransaction"})
    counter2 = Stats.get_counter()
    assert counter1.invocation_transactions + 1 == counter2.invocation_transactions
    assert counter1.total_transactions + 1 == counter2.total_transactions

    Stats.add_transaction_to_table(%{type: "InvocationTransaction", asset_moved: true})
    counter3 = Stats.get_counter()
    assert %{"true" => 1} == counter3.assets_transactions
  end

  test "add_transfer_to_table/1" do
    counter1 = Stats.get_counter()
    Stats.add_transfer_to_table(%{contract: "234556"})
    counter2 = Stats.get_counter()

    assert counter1.total_transfers + 1 == counter2.total_transfers
    assert %{"234556" => 1} == counter2.assets_transactions
  end

  test "get_attrs_for_type/2" do
    assert %{contract_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, contract_transactions: 13}, %{
               type: "ContractTransaction"
             })

    assert %{invocation_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, invocation_transactions: 13}, %{
               type: "InvocationTransaction"
             })

    assert %{enrollment_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, enrollment_transactions: 13}, %{
               type: "EnrollmentTransaction"
             })

    assert %{state_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, state_transactions: 13}, %{
               type: "StateTransaction"
             })

    assert %{claim_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, claim_transactions: 13}, %{
               type: "ClaimTransaction"
             })

    assert %{publish_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, publish_transactions: 13}, %{
               type: "PublishTransaction"
             })

    assert %{register_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, register_transactions: 13}, %{
               type: "RegisterTransaction"
             })

    assert %{issue_transactions: 14, total_transactions: 13} ==
             Stats.get_attrs_for_type(%{total_transactions: 12, issue_transactions: 13}, %{
               type: "IssueTransaction"
             })

    assert %{miner_transactions: 14} ==
             Stats.get_attrs_for_type(%{miner_transactions: 13}, %{type: "MinerTransaction"})
  end

  test "count_transactions/0" do
    assert [
             %{
               "ClaimTransaction" => 0,
               "ContractTransaction" => 0,
               "EnrollmentTransaction" => 0,
               "InvocationTransaction" => 0,
               "IssueTransaction" => 0,
               "MinerTransaction" => 0,
               "PublishTransaction" => 0,
               "RegisterTransaction" => 0,
               "StateTransaction" => 0
             },
             0,
             0
           ] == Stats.count_transactions()
  end

  test "count_addresses/0" do
    assert is_number(Stats.count_addresses())
  end

  test "count_blocks/0" do
    assert is_number(Stats.count_blocks())
  end

  test "count_transfers/0" do
    assert is_number(Stats.count_transfers())
  end

  test "check_if_nil/1" do
    assert 0 == Stats.check_if_nil(nil)
    assert 1 == Stats.check_if_nil(1)
  end
end
