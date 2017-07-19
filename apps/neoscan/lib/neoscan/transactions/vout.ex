defmodule Neoscan.Transactions.Vout do
  use Ecto.Schema
  import Ecto.Changeset


  schema "vouts" do
    field :asset, :string
    field :address, :string
    field :n, :integer
    field :value, :float


    belongs_to :transaction, Neoscan.Transactions.Transaction

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs \\ %{}) do
    transaction
    |> Ecto.build_assoc(:vouts)
    |> cast(attrs, [:asset, :address, :n, :value])
    |> assoc_constraint(:transaction, required: true)
    |> validate_required([:asset, :address, :n, :value])
  end
end
