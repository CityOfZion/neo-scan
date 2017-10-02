defmodule Neoscan.Transactions.Transaction do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :attributes, {:array, :map}
    field :net_fee, :string
    field :scripts, {:array, :map}
    field :size, :integer
    field :sys_fee, :string
    field :txid, :string
    field :type, :string
    field :version, :integer
    field :vin, {:array, :map}
    field :time, :integer
    field :block_hash, :string
    field :block_height, :integer
    field :nonce, :integer
    field :claims, {:array, :map}
    field :pubkey, :string
    field :asset, :map
    field :description, :string
    field :contract, :map

    field :asset_moved, :string

    has_many :vouts, Neoscan.Vouts.Vout
    belongs_to :block, Neoscan.Blocks.Block

    timestamps()
  end

  def changeset_with_block(block, attrs \\ %{}) do
    block
    |> Ecto.build_assoc(:transactions)
<<<<<<< HEAD
    |> cast(
         attrs,
         [
           :attributes,
           :net_fee,
           :nonce,
           :scripts,
           :size,
           :sys_fee,
           :txid,
           :type,
           :version,
           :vin,
           :time,
           :block_hash,
           :block_height,
           :claims,
           :pubkey,
           :asset,
           :description,
           :contract,
           :asset_moved
         ]
       )
=======
    |> cast(attrs, [:attributes, :net_fee, :nonce, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :time, :block_hash, :block_height, :claims, :pubkey, :asset, :description, :contract, :asset_moved])
>>>>>>> e1936f15b0149a19c966a1ae436bb9a8010e8ac7
    |> assoc_constraint(:block, required: true)
    |> validate_required(
         [
           :attributes,
           :net_fee,
           :scripts,
           :size,
           :sys_fee,
           :txid,
           :type,
           :version,
           :vin,
           :time,
           :block_hash,
           :block_height
         ]
       )
  end

  def update_changeset(transaction, attrs) do
    transaction
<<<<<<< HEAD
    |> cast(
         attrs,
         [
           :attributes,
           :net_fee,
           :nonce,
           :scripts,
           :size,
           :sys_fee,
           :txid,
           :type,
           :version,
           :vin,
           :time,
           :block_hash,
           :block_height,
           :claims,
           :pubkey,
           :asset,
           :description,
           :contract,
           :asset_moved
         ]
       )
=======
    |> cast(attrs, [:attributes, :net_fee, :nonce, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :time, :block_hash, :block_height, :claims, :pubkey, :asset, :description, :contract, :asset_moved])
>>>>>>> e1936f15b0149a19c966a1ae436bb9a8010e8ac7
    |> assoc_constraint(:block, required: true)
    |> validate_required(
         [
           :attributes,
           :net_fee,
           :scripts,
           :size,
           :sys_fee,
           :txid,
           :type,
           :version,
           :vin,
           :time,
           :block_hash,
           :block_height
         ]
       )
  end
end
