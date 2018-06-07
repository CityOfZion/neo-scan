defmodule Neoscan.Block do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema

  @primary_key {:hash, :binary, []}
  @foreign_key_type :binary
  schema "blocks" do
    field(:index, :integer)
    field(:merkleroot, :binary)
    field(:previousblockhash, :binary)
    field(:nextblockhash, :binary)
    field(:nextconsensus, :binary)
    field(:nonce, :binary)
    field(:script, {:map, :string})
    field(:size, :integer)
    field(:time, :utc_datetime)
    field(:version, :integer)
    field(:tx_count, :integer)
    field(:total_sys_fee, :float)
    field(:total_net_fee, :float)
    field(:gas_generated, :float)

    #    has_many(:transactions, Neoscan.Transactions.Transaction)
    #    has_many(:transfers, Neoscan.Transfers.Transfer)

    timestamps()
  end
end
