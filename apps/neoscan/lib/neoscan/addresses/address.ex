defmodule Neoscan.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address


  schema "addresses" do
    field :address, :string
    field :tx_ids, {:array, :strings}
    field :balance, :map
    has_many :vouts, Neoscan.Addresses.Address

    timestamps()
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:address, :tx_ids, :balance])
    |> validate_required([:address])
  end
end
