defmodule Neoscan.AddressQueue do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key false
  schema "addresses_queue" do
    field(:hash, :binary)
    field(:first_transaction_time, :utc_datetime)
    field(:last_transaction_time, :utc_datetime)
    field(:tx_count, :integer, default: 0)

    timestamps()
  end
end
