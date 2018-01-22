defmodule Neoscan.Transfers.Transfer do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Transfers.Transfer

  schema "transfers" do
    field(:address_from, :string)
    field(:address_to, :string)
    field(:amount, :float)
    field(:block_height, :integer)
    field(:txid, :string)
    field(:contract, :string)
    field(:time, :integer)

    timestamps()
  end

  @doc false
  def changeset(transaction_id, attrs \\ %{}) do
    new_attrs = Map.put(attrs, "txid", transaction_id)

    %Transfer{}
    |> cast(new_attrs, [:address_from, :address_to, :amount, :block_height, :txid, :contract, :type, :time])
    |> validate_required([:address_from, :address_to, :amount, :block_height, :txid, :contract, :type, :time])
  end

end
