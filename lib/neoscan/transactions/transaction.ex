defmodule Neoscan.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Transactions.Transaction


  schema "transactions_transaction" do
    field :attributes, :string
    field :blockhash, :string
    field :height, :string
    field :net_fee, :string
    field :scripts, :string
    field :size, :string
    field :sys_fee, :string
    field :time, :string
    field :txid, :string
    field :type, :string
    field :version, :string
    field :vin, :string
    field :vout, :string

    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:height, :blockhash, :time, :txid, :size, :type, :version, :attributes, :vin, :vout, :sys_fee, :net_fee, :scripts])
    |> validate_required([:height, :blockhash, :time, :txid, :size, :type, :version, :attributes, :vin, :vout, :sys_fee, :net_fee, :scripts])
  end
end
