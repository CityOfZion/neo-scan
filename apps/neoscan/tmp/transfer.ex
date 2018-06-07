defmodule Neoscan.Transfers.Transfer do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field(:address_from, :string)
    field(:address_to, :string)
    field(:amount, :float)
    field(:block_height, :integer)
    field(:txid, :string)
    field(:contract, :string)
    field(:time, :integer)
    field(:check_hash, :string)

    belongs_to(:block, Neoscan.Blocks.Block)

    timestamps()
  end
end
