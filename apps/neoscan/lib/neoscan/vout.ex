defmodule Neoscan.Vout do
  @moduledoc false
  use Ecto.Schema
  alias Neoscan.Transaction

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
    field(:address, :binary)
    field(:asset, :binary)
    field(:value, :float)

    timestamps()
  end
end
