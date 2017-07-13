defmodule Neoscan.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Transactions.Transaction


  schema "transactions" do
    field :attributes, {:array, :string}
    field :net_fee, :string
    field :nonce, :integer
    field :scripts, {:array, :string}
    field :size, :integer
    field :sys_fee, :string
    field :txid, :string
    field :type, :string
    field :version, :integer
    field :vin, {:array, :string}
    field :vout, {:array, :string}
    belongs_to :block, Neoscan.Blocks.Block

    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:attributes, :net_fee, :nonce, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :vout])
    |> assoc_constraint(:block)
    |> validate_required([:attributes, :net_fee, :nonce, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :vout])
  end
end
