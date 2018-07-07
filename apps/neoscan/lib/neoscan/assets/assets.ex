defmodule Neoscan.Assets do
  @moduledoc false

  alias Neoscan.Asset
  import Ecto.Query
  alias Neoscan.Repo

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def get_all do
    Repo.all(from(e in Asset))
  end
end
