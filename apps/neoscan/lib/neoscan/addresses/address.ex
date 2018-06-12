defmodule Neoscan.Address do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key {:hash, :binary, []}
  @foreign_key_type :binary
  schema "addresses" do
    field(:first_transaction_time, :utc_datetime)
    field(:last_transaction_time, :utc_datetime)
    field(:tx_count, :integer, default: 0)

    # has_many(:claimed, Neoscan.Claims.Claim)
    # has_many(:vouts, Neoscan.Vouts.Vout)
    # has_many(:histories, Neoscan.BalanceHistories.History)

    timestamps()
  end
end
