defmodule Neoscan.Stats.Counter do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Stats.Counter

  schema "counters" do
    field(:total_blocks, :integer)
    field(:total_transactions, :integer)
    field(:total_addresses, :integer)
    field(:contract_transactions, :integer)
    field(:invocation_transactions, :integer)
    field(:miner_transactions, :integer)
    field(:claim_transactions, :integer)
    field(:publish_transactions, :integer)
    field(:issue_transactions, :integer)
    field(:register_transactions, :integer)
    field(:enrollment_transactions, :integer)
    field(:state_transactions, :integer)
    field(:assets_transactions, {:map, :integer})
    field(:assets_addresses, {:map, :integer})
    field(:total_transfers, :integer)

    timestamps()
  end

  @doc false
  def changeset(attrs) do
    %Counter{}
    |> cast(attrs, [
      :total_blocks,
      :total_transactions,
      :total_addresses,
      :contract_transactions,
      :invocation_transactions,
      :miner_transactions,
      :claim_transactions,
      :publish_transactions,
      :issue_transactions,
      :register_transactions,
      :enrollment_transactions,
      :state_transactions,
      :assets_transactions,
      :assets_addresses,
      :total_transfers
    ])
  end

  def update_changeset(%Counter{} = counter, attrs) do
    counter
    |> cast(attrs, [
      :total_blocks,
      :total_transactions,
      :total_addresses,
      :contract_transactions,
      :invocation_transactions,
      :miner_transactions,
      :claim_transactions,
      :publish_transactions,
      :issue_transactions,
      :register_transactions,
      :enrollment_transactions,
      :state_transactions,
      :assets_transactions,
      :assets_addresses,
      :total_transfers
    ])
  end
end
