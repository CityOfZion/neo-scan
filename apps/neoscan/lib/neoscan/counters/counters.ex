defmodule Neoscan.Counters do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Counter
  alias Neoscan.BlockMeta

  def count_addresses do
    Repo.one(from(c in Counter, where: c.name == "addresses", select: c.value))
  end

  def count_blocks do
    Repo.one(from(c in BlockMeta, where: c.id == 1, select: c.index)) || 0
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

  def count_assets do
    Repo.one(from(c in Counter, where: c.name == "assets", select: c.value))
  end
end
