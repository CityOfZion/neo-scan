defmodule Neoscan.Vout do
  @moduledoc false
  use Ecto.Schema
  alias Neoscan.Transaction
  alias Neoscan.Address
  alias Neoscan.Asset

  @primary_key false
  schema "vouts" do
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

    field(:value, :float)
    field(:block_time, :utc_datetime)

    timestamps()
  end
end
