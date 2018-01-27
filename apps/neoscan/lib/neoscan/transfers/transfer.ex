defmodule Neoscan.Transfers.Transfer do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field(:address_from, :string)
    field(:address_to, :string)
    field(:amount, :float)
    field(:block_height, :integer)
    field(:txid, :string)
    field(:contract, :string)
    field(:time, :integer)

    belongs_to(:block, Neoscan.Blocks.Block)

    timestamps()
  end

  @doc false
  def changeset(block, attrs \\ %{}) do
    block
    |> Ecto.build_assoc(:transfers)
    |> cast(attrs, [
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :contract,
      :type,
      :time
    ])
    |> assoc_constraint(:block, required: true)
    |> validate_required([
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :contract,
      :type,
      :time
    ])
  end
end
