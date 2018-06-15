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
    query = from(e in Block, where: e.hash == ^hash)
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
    query = from(e in Block, where: e.index == ^height)
    Repo.one(query)
  end

  def get(hash) when is_binary(hash), do: get_block_by_hash(hash)

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

  def get_missing_block_indexes do
    query =
      "SELECT * FROM generate_series(0, (SELECT max(index) FROM blocks)) as index EXCEPT SELECT index FROM blocks"

    result = Ecto.Adapters.SQL.query!(Repo, query, [])
    List.flatten(result.rows)
  end

  def get_max_index do
    max_index = Repo.one(from(b in Block, order_by: [desc: b.index], limit: 1, select: b.index))
    if is_nil(max_index), do: -1, else: max_index
  end
end
