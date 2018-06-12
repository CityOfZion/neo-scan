defmodule Neoscan.Stats do
  @moduledoc false

  def count_addresses do
    0
  end

  def count_blocks do
    0
  end

  def count_transfers do
    0
  end

  def count_transactions do
    [
      %{
        "ContractTransaction" => 0,
        "ClaimTransaction" => 0,
        "InvocationTransaction" => 0,
        "MinerTransaction" => 0,
        "PublishTransaction" => 0,
        "IssueTransaction" => 0,
        "RegisterTransaction" => 0,
        "EnrollmentTransaction" => 0,
        "StateTransaction" => 0
      },
      0,
      0
    ]
  end

  def count_transactions_for_asset(_) do
    0
  end
end
