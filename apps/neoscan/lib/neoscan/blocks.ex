defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Block
  require Logger

  @doc """
  Returns the list of blocks in the home page.

  ## Examples

      iex> home_blocks()
      [%Block{}, ...]

  """
  def home_blocks, do: paginate_blocks(1)

  @doc """
  Gets a single block by its hash value
  ## Examples
      iex> get_block_by_hash(123)
      %Block{}
      iex> get_block_by_hash(456)
      nil
  """
  def get_block_by_hash(hash) do
    query =
      from(
        e in Block,
        where: e.hash == ^hash
      )

    Repo.one(query)
  end

  @doc """
  Gets a single block by its heigh value
  ## Examples
      iex> get_block_by_height(123)
      %Block{}
      iex> get_block_by_height(456)
      nill
  """
  def get_block_by_height(height) do
    query =
      from(
        e in Block,
        where: e.index == ^height
      )

    Repo.one(query)
  end

  @doc """
  Returns the list of paginated blocks.
  ## Examples
      iex> paginate_blocks(page)
      [%Block{}, ...]
  """
  def paginate_blocks(page) do
    block_query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        limit: 15
      )

    Repo.paginate(block_query, page: page, page_size: 15)
  end

  def paginate_transactions(_, _), do: []
end
