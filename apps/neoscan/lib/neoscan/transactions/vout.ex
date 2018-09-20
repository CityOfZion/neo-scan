defmodule Neoscan.Vout do
  @moduledoc false
  use Ecto.Schema
  alias Neoscan.Transaction
  alias Neoscan.Address
  alias Neoscan.Asset

  @primary_key false
  schema "vouts" do
    field(:transaction_id, :integer)

    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:n, :integer, primary_key: true)

    belongs_to(
      :address,
      Address,
      foreign_key: :address_hash,
      references: :hash,
      type: :binary
    )

    belongs_to(
      :asset,
      Asset,
      foreign_key: :asset_hash,
      references: :transaction_hash,
      type: :binary
    )

    field(:value, :decimal)
    field(:block_time, :utc_datetime)
    field(:claimed, :boolean)
    field(:spent, :boolean)
    field(:start_block_index, :integer)
    field(:end_block_index, :integer)

    timestamps()
  end
end
