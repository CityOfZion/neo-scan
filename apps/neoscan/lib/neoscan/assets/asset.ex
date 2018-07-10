defmodule Neoscan.Asset do
  @moduledoc false
  use Ecto.Schema

  alias Neoscan.Transaction

  @primary_key false
  schema "assets" do
    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary,
      primary_key: true
    )

    field(:admin, :binary)
    field(:amount, :float)
    field(:name, {:array, :map})
    field(:owner, :binary)
    field(:precision, :integer)
    field(:type, :string)
    field(:issued, :float)
    field(:block_time, :utc_datetime)
    field(:contract, :binary)

    timestamps()
  end

  def update_name(nil), do: nil

  def update_name(asset) do
    %{asset | name: filter_name(asset.name)}
  end

  def filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => "AntShare"} ->
        "NEO"

      %{"name" => "AntCoin"} ->
        "GAS"

      %{"name" => name} ->
        name

      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end

  def compute_value(amount, precision, "NEP5"), do: amount / :math.pow(10, precision)
  def compute_value(amount, _, _), do: amount

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
end
