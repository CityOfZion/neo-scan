defmodule NeoscanWeb.TransactionsView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias Neoscan.Helpers
  alias Neoscan.Assets

  import NeoscanWeb.CommonView

  def get_asset_name(_), do: "unknown"

  def apply_precision(asset, amount) do
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
