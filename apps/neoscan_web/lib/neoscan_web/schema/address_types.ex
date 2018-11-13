defmodule NeoscanWeb.Schema.AddressTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias NeoscanWeb.Resolvers.Address

  @desc "Queries for addresses"
  object :address_queries do
    @desc """
      Address query.
      Get information about one address.
      Use the filter to get the address by hash.
    """
    field :address, :address_row do
      arg(:hash, non_null(:string))
      resolve(&Address.get/3)
    end
  end

  @desc "a single address row"
  object :address_row do
    field(:first_transaction_time, :naive_datetime)
    field(:last_transaction_time, :naive_datetime)
    field(:tx_count, :integer)
    field(:atb_count, :integer)
    field(:hash, :binary58)
  end
end
