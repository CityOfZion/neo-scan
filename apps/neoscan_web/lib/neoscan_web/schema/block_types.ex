defmodule NeoscanWeb.Schema.BlockTypes do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias NeoscanWeb.Resolvers.Block

  @desc "Queries for blocks"
  object :block_queries do
    @desc "Blocks query"
    field :blocks, :blocks do
      arg(:paginator, :paginator)
      resolve(&Block.all/3)
    end
  end

  @desc "Blocks"
  object :blocks do
    field(:block_rows, type: list_of(:block_row))
    field(:pagination, type: :pagination)
  end

  @desc "Block"
  object :block_row do
    field(:cumulative_sys_fee, :decimal)
    field(:gas_generated, :decimal)
    field(:hash, :binary16)
    field(:index, :integer)
    field(:inserted_at, :naive_datetime)
    field(:lag, :integer)
    field(:merkle_root, :binary16)
    field(:next_consensus, :binary16)
    field(:nonce, :binary16)
    field(:script, :script)
    field(:size, :integer)
    field(:time, :datetime)
    field(:total_net_fee, :decimal)
    field(:total_sys_fee, :decimal)
    field(:tx_count, :integer)
    field(:updated_at, :naive_datetime)
    field(:version, :integer)
  end

  object :script do
    field(:invocation, :string)
    field(:verification, :string)
  end
end
