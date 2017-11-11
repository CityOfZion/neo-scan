defmodule NeoscanWeb.AssetsView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanMonitor.Api


  def get_supply(amount) when amount <= 0 do
    "Unlimited"
  end
  def get_supply(amount) when amount > 0 do
    amount
  end

end
