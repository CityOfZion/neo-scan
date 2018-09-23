defmodule Neoscan.Transfer do
  @moduledoc false
  use Ecto.Schema
  alias Neoscan.Transaction
  alias Neoscan.Asset

  @primary_key false
  schema "transfers" do
    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_id,
      references: :id,
      type: :integer
    )

    field(:address_from, :binary)
    field(:address_to, :binary)
    field(:amount, :decimal)

    belongs_to(
      :asset,
      Asset,
      foreign_key: :contract,
      references: :transaction_hash,
      type: :binary
    )

    field(:block_index, :integer)
    field(:block_time, :utc_datetime)

    timestamps()
  end
end
