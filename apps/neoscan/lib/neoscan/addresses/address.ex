defmodule Neoscan.Addresses.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address


  schema "addresses" do
    field :address, :string
    field :tx_ids, {:array, :strings}

    timestamps()
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [])
    |> validate_required([])
  end
end
