defmodule Neoscan.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address


  schema "addresses" do
    field :address, :string
    field :tx_ids, {:array, :string}
    field :balance, {:array, :map}
    field :claimed, {:array, :string}
    has_many :vouts, Neoscan.Addresses.Address

    timestamps()
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:address, :tx_ids, :balance, :claimed])
    |> validate_required([:address])
  end
end
