defmodule Neoscan.TxAbstracts.TxAbstract do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.TxAbstracts.TxAbstract

  schema "tx_abstracts" do
    field(:address_from, :string)
    field(:address_to, :string)
    field(:amount, :string)
    field(:block_height, :integer)
    field(:txid, :string)
    field(:asset, :string)
    field(:time, :integer)
    field(:check_hash, :string)

    timestamps()
  end

  @doc false
  def changeset(attrs \\ %{}) do
    check_hash = "#{attrs.txid}#{attrs.address_from}#{attrs.address_to}"

    new_attrs = Map.merge(attrs, %{:check_hash => check_hash, :amount => to_string(attrs.amount)})


    %TxAbstract{}
    |> cast(new_attrs, [
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :asset,
      :time,
      :check_hash,
    ])
    |> validate_required([
      :address_from,
      :address_to,
      :amount,
      :block_height,
      :txid,
      :asset,
      :time,
      :check_hash
    ])
  end
end
