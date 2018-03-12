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
    field(:check_hash, :string)

    belongs_to(:block, Neoscan.Blocks.Block)

    timestamps()
  end

  @doc false
  def changeset(block, attrs \\ %{}) do
    check_hash = "#{attrs["txid"]}#{attrs["address_from"]}#{attrs["address_to"]}"
    new_attrs = Map.put(attrs, "check_hash", check_hash)

    block
    |> Ecto.build_assoc(:transfers)
    |> cast(new_attrs, [
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :contract,
      :time,
      :check_hash
    ])
    |> assoc_constraint(:block, required: true)
    |> validate_required([
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :contract,
      :time,
      :check_hash
    ])
  end
end
