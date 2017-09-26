defmodule Neoscan.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address


  schema "addresses" do
    field :address, :string
    field :balance, :map

    has_many :claimed, Neoscan.Addresses.Claim
    has_many :vouts, Neoscan.Vouts.Vout
    has_many :histories, Neoscan.Addresses.History

    timestamps()
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:address, :balance])
    |> validate_required([:address])
  end
end
