defmodule NeoscanWeb.AssetsView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanCache.Api, as: CacheApi

  def get_supply(amount) when amount <= 0 do
    "Unlimited"
  end

  def get_supply(amount) when amount > 0 do
    number_to_delimited(amount)
  end
end
