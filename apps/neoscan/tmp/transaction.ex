defmodule Neoscan.Transactions.Transaction do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field(:attributes, {:array, :map})
    field(:net_fee, :string)
    field(:scripts, {:array, :map})
    field(:script, :string)
    field(:size, :integer)
    field(:sys_fee, :string)
    field(:txid, :string)
    field(:type, :string)
    field(:version, :integer)
    field(:vin, {:array, :map})
    field(:time, :integer)
    field(:block_hash, :string)
    field(:block_height, :integer)
    field(:nonce, :integer)
    field(:claims, {:array, :map})
    field(:pubkey, :string)
    field(:asset, :map)
    field(:description, :string)
    field(:contract, :map)
    field(:descriptors, {:array, :map})

    field(:asset_moved, :string)

    has_many(:vouts, Neoscan.Vouts.Vout)
    belongs_to(:block, Neoscan.Blocks.Block)

    timestamps()
  end
end
