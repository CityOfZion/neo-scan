defmodule Neoscan.AddressTransaction do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  alias Neoscan.Address
  alias Neoscan.Transaction

  @primary_key false
  schema "address_transactions" do
    field(:transaction_id, :integer)

    belongs_to(
      :address,
      Address,
      foreign_key: :address_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:block_time, :utc_datetime)

    timestamps()
  end
end
