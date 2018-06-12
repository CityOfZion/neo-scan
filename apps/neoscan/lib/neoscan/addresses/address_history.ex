defmodule Neoscan.AddressHistory do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  alias Neoscan.Address

  @primary_key false
  schema "address_histories" do
    belongs_to(
      :address,
      Address,
      foreign_key: :address_hash,
      references: :hash,
      type: :binary
    )

    field(:asset, :binary)
    field(:value, :float)
    field(:block_time, :utc_datetime)

    timestamps()
  end
end
