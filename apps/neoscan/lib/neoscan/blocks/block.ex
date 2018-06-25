defmodule Neoscan.Block do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema
  alias Neoscan.Transaction

  @primary_key {:hash, :binary, []}
  @foreign_key_type :binary
  schema "blocks" do
    field(:index, :integer)
    field(:merkle_root, :binary)
    field(:next_consensus, :binary)
    field(:nonce, :binary)
    field(:script, {:map, :string})
    field(:size, :integer)
    field(:time, :utc_datetime)
    field(:version, :integer)
    field(:tx_count, :integer)
    field(:total_sys_fee, :float)
    field(:total_net_fee, :float)
    field(:gas_generated, :float)
    has_many(:transactions, Transaction, foreign_key: :block_hash, references: :hash)
    #    has_many(:transfers, Neoscan.Transfers.Transfer)

    timestamps()
  end
end
