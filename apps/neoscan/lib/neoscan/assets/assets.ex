defmodule Neoscan.Assets do
  @moduledoc """
  The boundary for the Assets system.
  """

  @page_size 15

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Asset

  @doc """
  Gets a single asset by its hash value
  ## Examples
      iex> get(123)
      %Block{}
      iex> get(456)
      nill
  """
  def get(hash) do
    Repo.one(from(e in Asset, where: e.transaction_hash == ^hash))
  end

  @doc """
  Returns the list of paginated assets.
  ## Examples
      iex> paginate(page)
      [%Asset{}, ...]
  """
  def paginate(page) do
    assets_query = from(e in Asset, order_by: [desc: e.block_time], limit: @page_size)
    Repo.paginate(assets_query, page: page, page_size: @page_size)
  end
end
