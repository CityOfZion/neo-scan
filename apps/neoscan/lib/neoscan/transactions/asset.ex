defmodule Neoscan.Transactions.Asset do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Transactions.Asset


  schema "assets" do
    field :txid, :string


    timestamps()
  end

  @doc false
  def changeset(transaction_id,  attrs \\ %{}) do
    new_attrs = Map.put(attrs, "txid", transaction_id)
    IO.inspect(new_attrs)
    %Asset{}
    |> cast(new_attrs, [:txid])
    |> validate_required([:txid])
  end
end
