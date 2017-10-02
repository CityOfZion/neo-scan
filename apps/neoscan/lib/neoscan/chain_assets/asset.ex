defmodule Neoscan.ChainAssets.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.ChainAssets.Asset

  schema "assets" do
    field :txid, :string  #assets are referenced by their register transaction txid
    field :admin, :string
    field :amount, :float
    field :name, {:array, :map}
    field :owner, :string
    field :precision, :integer
    field :type, :string
    field :issued, :float

    field :time, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction_id, attrs \\ %{}) do
    new_attrs = Map.put(attrs, "txid", transaction_id)
    %Asset{}
    |> cast(new_attrs, [:txid, :admin, :amount, :name, :owner, :precision, :type, :issued, :time])
    |> validate_required([:txid,:admin, :amount, :name, :owner, :precision, :type, :time])
  end

  def update_changeset(asset, attrs \\ %{}) do
    asset
    |> cast(attrs, [:issued])
  end
end
