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
end
