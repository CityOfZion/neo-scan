defmodule Neoscan.Counters do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Counter
  alias Neoscan.AddressBalance
  alias Neoscan.AddressTransactionBalance

  def count_addresses do
    Repo.one(from(c in Counter, where: c.name == "addresses", select: c.value))
  end

  def count_addresses(asset_hash) do
    Repo.one(from(ab in AddressBalance, where: ab.asset_hash == ^asset_hash, select: count(1)))
  end

  def count_blocks do
    Repo.one(from(c in Counter, where: c.name == "blocks", select: c.value))
  end

  def _count_transactions do
    Repo.one(from(c in Counter, where: c.name == "transactions", select: c.value))
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
      _count_transactions(),
      0
    ]
  end

  def count_transactions(asset_hash) do
    Repo.one(
      from(
        atb in AddressTransactionBalance,
        where: atb.asset_hash == ^asset_hash,
        select: count(atb.transaction_hash, :distinct)
      )
    )
  end

  def count_assets do
    Repo.one(from(c in Counter, where: c.name == "assets", select: c.value))
  end
end
