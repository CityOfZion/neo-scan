defmodule Neoscan.AddressHistory do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  alias Neoscan.Address
  alias Neoscan.Transaction

  @primary_key false
  schema "address_histories" do
    belongs_to(
      :address,
      Address,
      foreign_key: :address_hash,
      references: :hash,
      type: :binary
    )

    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary
    )

    field(:asset, :binary)
    field(:value, :float)
    field(:block_time, :utc_datetime)

    timestamps()
  end
end
