defmodule NeoscanWeb.SharedView do
  use NeoscanWeb, :view
  import NeoscanWeb.CommonView
  alias Neoscan.Helpers
  alias Neoscan.Assets

  def apply_precision(asset, amount) do
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
