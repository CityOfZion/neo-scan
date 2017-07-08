defmodule Neoscan.Blocks.Block do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Blocks.Block


  schema "blocks_block" do
    field :hash, :string
    field :height, :string
    field :merkleroot, :string
    field :nextminer, :string
    field :nonce, :string
    field :previousblockhash, :string
    field :script, :map
    field :size, :string
    field :time, :string
    field :version, :string

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [:hash, :size, :version, :previousblockhash, :merkleroot, :time, :height, :nonce, :nextminer, :script])
    |> validate_required([:hash, :size, :version, :previousblockhash, :merkleroot, :time, :height, :nonce, :nextminer, :script])
  end
end
