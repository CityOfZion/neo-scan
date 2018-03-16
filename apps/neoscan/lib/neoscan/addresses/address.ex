defmodule Neoscan.Addresses.Address do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address

  schema "addresses" do
    field(:address, :string)
    field(:balance, :map)
    field(:time, :integer)
    field(:tx_count, :integer, default: 0)

    has_many(:claimed, Neoscan.Claims.Claim)
    has_many(:vouts, Neoscan.Vouts.Vout)
    has_many(:histories, Neoscan.BalanceHistories.History)

    timestamps()
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:address, :balance, :time])
    |> unique_constraint(:address)
    |> validate_required([:address, :time, :tx_count])
  end

  def update_changeset(%Address{} = address, attrs) do
    new_attrs = Map.put(attrs, :tx_count, address.tx_count + 1)

    address
    |> cast(new_attrs, [:balance, :tx_count])
  end
end
