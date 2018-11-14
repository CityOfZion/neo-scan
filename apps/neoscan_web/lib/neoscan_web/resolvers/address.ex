defmodule NeoscanWeb.Resolvers.Address do
  @moduledoc false
  alias Neoscan.Addresses

  def get(_, %{hash: hash}, _) do
    hash = Base58.decode(hash)
    address = Addresses.get(hash)
    if is_nil(address), do: {:error, "address not found"}, else: {:ok, address}
  end

  def get(_, _, _), do: {:error, "missing search parameter hash"}

  def get_gas_generated(%{hash: hash}, %{start_block: start_block, end_block: end_block}, _) do
    {:ok, NeoscanWeb.Api.get_gas_generated(hash, start_block, end_block)}
  end
end
