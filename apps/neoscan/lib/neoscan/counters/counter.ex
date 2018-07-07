defmodule Neoscan.Counter do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key {:name, :string, []}
  schema "counters" do
    field(:value, :integer)
  end
end
