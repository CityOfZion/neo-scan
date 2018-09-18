defmodule Neoscan.Counter do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key false
  schema "counters" do
    field(:name, :string, primary_key: true)
    field(:ref, :binary, primary_key: true)
    field(:value, :integer)
  end
end
