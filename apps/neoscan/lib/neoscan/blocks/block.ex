defmodule Neoscan.Blocks.Block do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.BlockGasGeneration
  alias Neoscan.Blocks.Block

  schema "blocks" do
    field(:confirmations, :integer)
    field(:hash, :string)
    field(:index, :integer)
    field(:merkleroot, :string)
    field(:nextblockhash, :string)
    field(:nextconsensus, :string)
    field(:nonce, :string)
    field(:previousblockhash, :string)
    field(:script, {:map, :string})
    field(:size, :integer)
    field(:time, :integer)
    field(:version, :integer)
    field(:tx_count, :integer)
    field(:total_sys_fee, :float)
    field(:total_net_fee, :float)
    field(:gas_generated, :float)

    has_many(:transactions, Neoscan.Transactions.Transaction)
    has_many(:transfers, Neoscan.Transfers.Transfer)

    timestamps()
  end

  @doc false
  def changeset(%Block{} = block, attrs) do
    new_attrs =
      Map.merge(attrs, %{
        "hash" => String.slice(to_string(attrs["hash"]), -64..-1),
        "nextblockhash" => String.slice(to_string(attrs["nextblockhash"]), -64..-1),
        "previousblockhash" => String.slice(to_string(attrs["previousblockhash"]), -64..-1),
        "merkleroot" => String.slice(to_string(attrs["merkleroot"]), -64..-1),
        "gas_generated" => BlockGasGeneration.get_amount_generate_in_block(attrs["index"])
      })

    block
    |> cast(new_attrs, [
      :confirmations,
      :hash,
      :size,
      :version,
      :previousblockhash,
      :merkleroot,
      :time,
      :index,
      :nonce,
      :nextblockhash,
      :script,
      :nextconsensus,
      :tx_count,
      :total_sys_fee,
      :total_net_fee,
      :gas_generated
    ])
    |> validate_required([
      :confirmations,
      :hash,
      :size,
      :version,
      :previousblockhash,
      :merkleroot,
      :time,
      :index,
      :nonce,
      :nextblockhash,
      :script,
      :nextconsensus,
      :tx_count,
      :total_sys_fee,
      :total_net_fee,
      :gas_generated
    ])
  end
end
