defmodule Neoscan.Block do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema
  alias Neoscan.Script
  alias Neoscan.Transaction

  @primary_key {:index, :integer, []}
  @foreign_key_type :integer
  schema "blocks" do
    field(:hash, :binary)
    field(:merkle_root, :binary)
    field(:next_consensus, :binary)
    field(:nonce, :binary)
    embeds_one(:script, Script)
    field(:size, :integer)
    field(:time, :utc_datetime)
    field(:lag, :integer, virtual: true)
    field(:version, :integer)
    field(:tx_count, :integer)
    field(:total_sys_fee, :decimal)
    field(:total_net_fee, :decimal)
    field(:cumulative_sys_fee, :decimal)
    field(:gas_generated, :decimal)
    has_many(:transactions, Transaction, foreign_key: :block_index, references: :index)

    timestamps()
  end
end
