defmodule Neoscan.CounterQueue do
  @moduledoc """
  Represent a Address in Database.
  """
  use Ecto.Schema

  @primary_key false
  schema "counters_queue" do
    field(:name, :string)
    field(:ref, :binary)
    field(:value, :integer)
  end
end
