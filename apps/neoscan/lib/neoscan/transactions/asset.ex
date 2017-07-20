defmodule Neoscan.Transactions.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Transactions.Asset


  schema "assets" do
    field :txid, :string  #assets are referenced by their register transaction txid
    field :admin, :string
    field :amount, :float
    field :name, {:array, :map}
    field :owner, :string
    field :precision, :integer
    field :type, :string


    timestamps()
  end

  @doc false
  def changeset(transaction_id,  attrs \\ %{}) do
    new_attrs = Map.put(attrs, "txid", transaction_id)
    %Asset{}
    |> cast(new_attrs, [:txid, :admin, :amount, :name, :owner, :precision, :type])
    |> validate_required([:txid,:admin, :amount, :name, :owner, :precision, :type])
  end
end
