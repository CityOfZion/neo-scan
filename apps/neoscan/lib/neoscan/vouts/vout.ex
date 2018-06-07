defmodule Neoscan.Vouts.Vout do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Vouts.Vout
  alias Neoscan.ChainAssets

  schema "vouts" do
    field(:asset, :string)
    field(:address_hash, :string)
    field(:n, :integer)
    field(:value, :float)
    field(:time, :integer)

    field(:start_height, :integer)
    field(:end_height, :integer)
    field(:claimed, :boolean)

    # colum for composed query indexing
    field(:query, :string)

    belongs_to(
      :transaction,
      Neoscan.Transactions.Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary
    )

    belongs_to(:address, Neoscan.Addresses.Address)
    timestamps()
  end

  @doc false
  def changeset(
        %{
          :hash => transaction_hash,
          :time => time,
          :block_height => height
        },
        %{
          "address" => {address, _attrs},
          "value" => value,
          "n" => n,
          "asset" => asset
        } = attrs
      ) do
    {new_value, _} = Float.parse(value)

    verified_asset = ChainAssets.verify_asset(String.slice(to_string(asset), -64..-1), time)

    new_attrs =
      attrs
      |> Map.merge(%{
        "start_height" => height,
        "claimed" => false,
        "time" => time,
        "asset" => verified_asset,
        "address_id" => address.id,
        "transaction_hash" => transaction_hash,
        "address_hash" => address.address,
        "value" => new_value,
        "query" => "#{Base.encode16(transaction_hash)}#{n}"
      })
      |> Map.delete("address")

    %Vout{}
    |> cast(new_attrs, [
      :asset,
      :address_hash,
      :n,
      :value,
      :address_id,
      :transaction_hash,
      :query,
      :time,
      :start_height,
      :end_height,
      :claimed
    ])
    |> assoc_constraint(:transaction, required: true)
    |> assoc_constraint(:address, required: true)
    |> validate_required([
      :asset,
      :address_hash,
      :n,
      :value,
      :query,
      :time,
      :start_height
    ])
  end

  def update_changeset(vout, %{:end_height => _endheight} = attrs) do
    vout
    |> cast(attrs, [:end_height])
  end

  def update_changeset(vout, %{:claimed => _claimed} = attrs) do
    vout
    |> cast(attrs, [:claimed])
  end
end
