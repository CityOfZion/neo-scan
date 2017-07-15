defmodule Neoscan.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :attributes, {:array, :string}
    field :net_fee, :string
    field :scripts, {:array, :string}
    field :size, :integer
    field :sys_fee, :string
    field :txid, :string
    field :type, :string
    field :version, :integer
    field :vin, {:array, :string}
    field :vout, {:array, :string}

    field :time, :integer
    field :block_hash, :string
    field :block_height, :integer

    field :nonce, :integer
    field :claims, {:array, :string}
    field :pubkey, :string
    field :asset, {:array, :string}
    field :description, :string
    field :contract, :string


    belongs_to :block, Neoscan.Blocks.Block

    timestamps()
  end

  @doc false
  def changeset(block, attrs \\ %{}) do
    block
    |> Ecto.build_assoc(:transactions)
    |> cast(attrs, [:attributes, :net_fee, :nonce, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :vout, :time, :block_hash, :block_height, :claims, :pubkey, :asset, :description, :contract])
    |> assoc_constraint(:block, required: true)
    |> validate_required([:attributes, :net_fee, :scripts, :size, :sys_fee, :txid, :type, :version, :vin, :vout, :time, :block_hash, :block_height])
  end
end
