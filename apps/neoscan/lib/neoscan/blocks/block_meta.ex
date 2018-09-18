defmodule Neoscan.BlockMeta do
  @moduledoc """
  Represent a Block in Database
  """

  use Ecto.Schema

  @primary_key {:id, :integer, []}
  schema "blocks_meta" do
    field(:index, :integer)
    field(:cumulative_sys_fee, :decimal)
  end
end
