defmodule Neoscan.Blocks.Block do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Blocks.Block


  schema "blocks" do
    field :confirmations, :integer
    field :hash, :string
    field :index, :integer
    field :merkleroot, :string
    field :nextblockhash, :string
    field :nextconsensus, :string
    field :nonce, :string
    field :previousblockhash, :string
    field :script, {:map , :string}
    field :size, :integer
    field :time, :integer
    field :version, :integer
    has_many :transactions, Neoscan.Transactions.Transaction

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    block
    |> cast(attrs, [:confirmations, :hash, :size, :version, :previousblockhash, :merkleroot, :time, :index, :nonce, :nextblockhash, :script, :nextconsensus])
    |> cast_assoc(:transactions, required: false)
    |> validate_required([:confirmations, :hash, :size, :version, :previousblockhash, :merkleroot, :time, :index, :nonce, :nextblockhash, :script, :nextconsensus])
  end
end
