defmodule Neoscan.Script do
  @moduledoc false
  use Ecto.Schema

  embedded_schema do
    field(:invocation, :string)
    field(:verification, :string)
  end
end
