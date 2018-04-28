defmodule Neoscan.ChainAssets.Asset do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.ChainAssets.Asset

  schema "assets" do
    # assets are referenced by their register transaction txid
    field(:txid, :string)
    field(:admin, :string)
    field(:amount, :float)
    field(:name, {:array, :map})
    field(:owner, :string)
    field(:precision, :integer)
    field(:type, :string)
    field(:issued, :float)
    field(:contract, :string)

    field(:time, :integer)

    timestamps()
  end

  @doc false
  def changeset(transaction_id, attrs \\ %{}) do
    new_attrs = Map.put(attrs, "txid", transaction_id)

    %Asset{}
    |> cast(new_attrs, [
      :txid,
      :admin,
      :amount,
      :name,
      :owner,
      :precision,
      :type,
      :issued,
      :time,
      :contract
    ])
    |> unique_constraint(:txid, name: :assets_txid_name_index)
    |> unique_constraint(:contract)
    |> validate_required([:txid, :admin, :amount, :name, :owner, :precision, :type, :time])
  end

  def update_changeset(asset, attrs \\ %{}) do
    asset
    |> cast(attrs, [:issued])
  end
end
