defmodule Neoscan.Transactions.Vout do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses
  alias Neoscan.Transactions.Vout


  schema "vouts" do
    field :asset, :string
    field :address_hash, :string
    field :n, :integer
    field :value, :float


    belongs_to :transaction, Neoscan.Transactions.Transaction
    belongs_to :address, Neoscan.Addresses.Address
    timestamps()
  end

  @doc false
  def changeset(%{:id => transaction_id}, %{"address" => address_hash} = attrs \\ %{}) do
    %{:id => address_id} = Addresses.create_or_get(address_hash)
    new_attrs= attrs
    |> Map.put("address_id", address_id)
    |> Map.put("transaction_id", transaction_id)
    |> Map.put("address_hash", address_hash)
    |> Map.delete("address")
    %Vout{}
    |> cast(new_attrs, [:asset, :address_hash, :n, :value, :address_id, :transaction_id])
    |> assoc_constraint(:transaction, required: true)
    |> assoc_constraint(:address, required: true)
    |> validate_required([:asset, :address_hash, :n, :value])
  end
end
