defmodule Neoscan.Vouts.Vout do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Vouts.Vout
  alias Neoscan.ChainAssets

  schema "vouts" do
    field(:asset, :string)
    field(:address_hash, :string)
    field(:n, :integer)
    field(:value, :float)
    field(:txid, :string)
    field(:time, :integer)

    field(:start_height, :integer)
    field(:end_height, :integer)
    field(:claimed, :boolean)

    # colum for composed query indexing
    field(:query, :string)

    belongs_to(:transaction, Neoscan.Transactions.Transaction)
    belongs_to(:address, Neoscan.Addresses.Address)
    timestamps()
  end
end
