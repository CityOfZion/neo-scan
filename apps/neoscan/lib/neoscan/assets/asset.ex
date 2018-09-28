defmodule Neoscan.Asset do
  @moduledoc false
  use Ecto.Schema

  alias Neoscan.Transaction

  @primary_key false
  schema "assets" do
    field(:transaction_id, :integer)

    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:admin, :binary)
    field(:amount, :decimal)
    field(:name, :map)
    field(:owner, :binary)
    field(:precision, :integer)
    field(:type, :string)
    field(:symbol, :string)
    field(:issued, :decimal)
    field(:block_time, :utc_datetime)
    field(:contract, :binary)

    timestamps()
  end

  def update_name(nil), do: nil

  def update_name(asset) do
    %{asset | name: filter_name(asset.name)}
  end

  def filter_name(%{"en" => "AntShare"}), do: "NEO"
  def filter_name(%{"en" => "AntCoin"}), do: "GAS"
  def filter_name(%{"en" => name}), do: name
  def filter_name(map), do: hd(Map.values(map))

  def compute_value(amount, precision, "NEP5"),
    do: Decimal.div(amount, round(:math.pow(10, precision))) |> Decimal.reduce()

  def compute_value(amount, _, _), do: amount |> Decimal.reduce()

  def update_struct(
        %{amount: amount, asset: %{precision: precision, type: type, name: name} = asset} = struct
      ) do
    %{
      struct
      | amount: compute_value(amount, precision, type),
        asset: %{asset | name: filter_name(name)}
    }
  end

  def update_struct(
        %{value: value, asset: %{precision: precision, type: type, name: name} = asset} = struct
      ) do
    %{
      struct
      | value: compute_value(value, precision, type),
        asset: %{asset | name: filter_name(name)}
    }
  end

  def update_struct(struct), do: struct
end
