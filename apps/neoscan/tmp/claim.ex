defmodule Neoscan.Claims.Claim do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Claims.Claim

  schema "claims" do
    field(:address_hash, :string)
    field(:txids, {:array, :string})
    field(:asset, :string)
    field(:amount, :float)

    field(:block_height, :integer)
    field(:time, :integer)

    belongs_to(:address, Neoscan.Addresses.Address)
    timestamps()
  end
end
