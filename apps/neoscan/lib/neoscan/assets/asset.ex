defmodule Neoscan.Asset do
  @moduledoc false
  use Ecto.Schema

  alias Neoscan.Transaction

  @primary_key false
  schema "assets" do
    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:admin, :binary)
    field(:amount, :float)
    field(:name, {:array, :map})
    field(:owner, :binary)
    field(:precision, :integer)
    field(:type, :string)
    field(:issued, :float)
    field(:block_time, :utc_datetime)
    field(:contract, :binary)

    timestamps()
  end
end
