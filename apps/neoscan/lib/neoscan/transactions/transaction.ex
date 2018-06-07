defmodule Neoscan.Transactions.Transaction do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:hash, :binary, []}
  @foreign_key_type :binary
  schema "transactions" do
    field(:attributes, {:array, :map})
    field(:net_fee, :string)
    field(:scripts, {:array, :map})
    field(:script, :string)
    field(:size, :integer)
    field(:sys_fee, :string)

    field(:type, :string)
    field(:version, :integer)
    field(:vin, {:array, :map})
    field(:time, :integer)
    field(:block_height, :integer)
    field(:nonce, :integer)
    field(:claims, {:array, :map})
    field(:pubkey, :string)
    field(:asset, :map)
    field(:description, :string)
    field(:contract, :map)
    field(:descriptors, {:array, :map})

    field(:asset_moved, :string)

    has_many(:vouts, Neoscan.Vouts.Vout, foreign_key: :transaction_hash, references: :hash)

    belongs_to(
      :block,
      Neoscan.Blocks.Block,
      foreign_key: :block_hash,
      references: :hash,
      type: :binary
    )

    timestamps()
  end

  def changeset_with_block(block, attrs \\ %{}) do
    block
    |> Ecto.build_assoc(:transactions)
    |> cast(attrs, [
      :attributes,
      :net_fee,
      :nonce,
      :scripts,
      :size,
      :sys_fee,
      :hash,
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
      :asset_moved,
      :script,
      :descriptors
    ])
    |> assoc_constraint(:block, required: true)
    |> unique_constraint(:hash)
    |> validate_required([
      :attributes,
      :net_fee,
      :scripts,
      :size,
      :sys_fee,
      :hash,
      :type,
      :version,
      :vin,
      :time,
      :block_hash,
      :block_height
    ])
  end

  def update_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :attributes,
      :net_fee,
      :nonce,
      :scripts,
      :size,
      :sys_fee,
      :hash,
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
      :asset_moved,
      :script,
      :descriptors
    ])
    |> assoc_constraint(:block, required: true)
    |> validate_required([
      :attributes,
      :net_fee,
      :scripts,
      :size,
      :sys_fee,
      :hash,
      :type,
      :version,
      :vin,
      :time,
      :block_hash,
      :block_height
    ])
  end
end
