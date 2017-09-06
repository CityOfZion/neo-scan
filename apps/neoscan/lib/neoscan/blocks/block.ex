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
    field :tx_count, :integer
    has_many :transactions, Neoscan.Transactions.Transaction

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    new_attrs = Map.merge(attrs, %{
         "hash" =>  String.slice(attrs["hash"], -64..-1),
         "nextblockhash" => String.slice(attrs["nextblockhash"], -64..-1),
         "previousblockhash" => String.slice(attrs["previousblockhash"], -64..-1),
         "merkleroot" => String.slice(attrs["merkleroot"], -64..-1),
      })
    block
    |> cast(new_attrs, [:confirmations, :hash, :size, :version, :previousblockhash, :merkleroot, :time, :index, :nonce, :nextblockhash, :script, :nextconsensus, :tx_count])
    |> validate_required([:confirmations, :hash, :size, :version, :previousblockhash, :merkleroot, :time, :index, :nonce, :nextblockhash, :script, :nextconsensus, :tx_count])
  end
end
