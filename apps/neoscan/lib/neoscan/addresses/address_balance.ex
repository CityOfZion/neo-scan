defmodule Neoscan.AddressBalance do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  alias Neoscan.Address
  alias Neoscan.Asset

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

    belongs_to(
      :asset,
      Asset,
      foreign_key: :asset_hash,
      references: :transaction_hash,
      type: :binary,
      primary_key: true
    )

    field(:value, :decimal)

    timestamps()
  end
end
