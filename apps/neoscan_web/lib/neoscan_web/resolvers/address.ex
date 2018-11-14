defmodule NeoscanWeb.Resolvers.Address do
  @moduledoc false
  alias Neoscan.Addresses

  def get(_, %{hash: hash}, _) do
    hash = Base58.decode(hash)
    address = Addresses.get(hash)
    if is_nil(address), do: {:error, "address not found"}, else: {:ok, address}
  end

  def get(_, _, _), do: {:error, "missing search parameter hash"}

  def get_gas_generated(_, _, _) do
    {:ok, Decimal.new("12.21")}
  end
end
