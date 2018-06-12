defmodule Neoscan.AddressBalance do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  alias Neoscan.Address

  @primary_key false
  schema "address_balances" do
    belongs_to(
      :address,
      Address,
      foreign_key: :address_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:asset, :binary, primary_key: true)
    field(:value, :float)

    timestamps()
  end
end
