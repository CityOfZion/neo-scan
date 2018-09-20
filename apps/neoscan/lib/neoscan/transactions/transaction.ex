defmodule Neoscan.Transaction do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema
  alias Neoscan.Block
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Claim
  alias Neoscan.Transfer
  alias Neoscan.Asset

  @primary_key {:hash, :binary, []}
  @foreign_key_type :binary
  schema "transactions" do
    belongs_to(:block, Block, foreign_key: :block_hash, references: :hash, type: :binary)
    field(:id, :integer)
    field(:block_index, :integer)
    field(:block_time, :utc_datetime)
    field(:attributes, {:array, :map})
    field(:net_fee, :decimal)
    field(:sys_fee, :decimal)
    field(:nonce, :integer)
    field(:scripts, {:array, :map})
    field(:size, :integer)
    field(:type, :string)
    field(:version, :integer)
    field(:n, :integer)
    has_many(:vouts, Vout, foreign_key: :transaction_hash, references: :hash)
    has_many(:vins, Vin, foreign_key: :transaction_hash, references: :hash)
    has_many(:claims, Claim, foreign_key: :transaction_hash, references: :hash)
    has_many(:transfers, Transfer, foreign_key: :transaction_hash, references: :hash)
    has_one(:asset, Asset, foreign_key: :transaction_hash, references: :hash)

    timestamps()
  end
end
