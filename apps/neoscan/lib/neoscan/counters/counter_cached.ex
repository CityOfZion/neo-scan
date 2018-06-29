defmodule Neoscan.CounterCached do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key {:name, :string, []}
  schema "counters_cached" do
    field(:value, :integer)
  end
end
