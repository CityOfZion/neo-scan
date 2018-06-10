defmodule Neoscan.Vin do
  @moduledoc false
  use Ecto.Schema
  alias Neoscan.Transaction

  @primary_key false
  schema "vins" do
    belongs_to(
      :transaction,
      Transaction,
      foreign_key: :transaction_hash,
      references: :hash,
      type: :binary
    )

    field(:vout_transaction_hash, :binary)
    field(:vout_n, :integer)
    field(:block_time, :utc_datetime)
    field(:processed, :boolean)

    timestamps()
  end
end
