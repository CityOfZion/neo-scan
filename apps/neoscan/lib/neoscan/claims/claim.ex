defmodule Neoscan.Claims.Claim do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Claims.Claim


  schema "claims" do
    field :address_hash, :string
    field :txids, {:array, :string}
    field :asset, :string
    field :amount, :float

    field :block_height, :integer
    field :time, :integer

    belongs_to :address, Neoscan.Addresses.Address
    timestamps()
  end

  @doc false
  def changeset(%Claim{} = claim, address, attrs) do

    new_attrs = Map.merge(attrs, %{
      :address_id => address.id,
      :address_hash => address.address,
      })

    claim
    |> cast(new_attrs, [:address_hash, :txids, :asset, :amount, :block_height, :address_id, :time])
    |> assoc_constraint(:address, required: true)
    |> validate_required([:address_hash, :txids, :asset, :amount, :block_height, :address_id, :time])
  end

end
