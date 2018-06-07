defmodule Neoscan.ChainAssets.Asset do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.ChainAssets.Asset

  @primary_key {:transaction_hash, :binary, []}
  @foreign_key_type :binary
  schema "assets" do
    # assets are referenced by their register transaction txid
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
  def changeset(transaction_hash, attrs \\ %{}) do
    new_attrs = Map.put(attrs, "transaction_hash", transaction_hash)

    %Asset{}
    |> cast(new_attrs, [
      :transaction_hash,
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
    # |> unique_constraint(:transaction_hash)
    |> unique_constraint(:contract)
    |> validate_required([
      :transaction_hash,
      :admin,
      :amount,
      :name,
      :owner,
      :precision,
      :type,
      :time
    ])
  end

  def update_changeset(asset, attrs \\ %{}) do
    asset
    |> cast(attrs, [:issued])
  end
end
