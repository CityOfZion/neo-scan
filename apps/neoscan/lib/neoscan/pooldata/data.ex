defmodule Neoscan.Pool.Data do
  use Ecto.Schema
  import Ecto.Changeset
  alias Neoscan.Pool.Data


  schema "data" do
    field :height, :integer
    field :block, :map
  end

  @doc false
  def changeset(%Data{} = data, attrs) do
    data
    |> cast(attrs, [:height, :block])
    |> validate_required([:height, :block ])
  end
end
