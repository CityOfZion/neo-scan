defmodule Neoscan.Addresses.Address do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Addresses.Address

  schema "addresses" do
    field(:address, :string)
    field(:balance, :map)
    field(:time, :integer)
    field(:tx_count, :integer, default: 0)

    has_many(:claimed, Neoscan.Claims.Claim)
    has_many(:vouts, Neoscan.Vouts.Vout)
    has_many(:histories, Neoscan.BalanceHistories.History)

    timestamps()
  end
end
