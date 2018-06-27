defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Block
  require Logger

  @page_size 15

  @doc """
  Gets a single block by its height or hash value
  ## Examples
      iex> get(123)
      %Block{}
      iex> get(456)
      nill
  """
  def get(hash) when is_binary(hash), do: Repo.one(from(e in Block, where: e.hash == ^hash))
  def get(index) when is_integer(index), do: Repo.one(from(e in Block, where: e.index == ^index))

  @doc """
  Returns the list of paginated blocks.
  ## Examples
      iex> paginate(page)
      [%Block{}, ...]
  """
  def paginate(page) do
    block_query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        limit: @page_size
      )

    Repo.paginate(block_query, page: page, page_size: @page_size)
  end

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

  def get_fees_in_range(min, max) do
    query =
      from(
        b in Block,
        where: b.index >= ^min and b.index < ^max,
        select: %{
          :total_sys_fee => sum(b.total_sys_fee),
          :total_net_fee => sum(b.total_net_fee)
        }
      )

    Repo.one(query)
  end
end
