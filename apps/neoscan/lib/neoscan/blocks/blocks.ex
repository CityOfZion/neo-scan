defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Transfer
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
  def get(hash) do
    block = _get(hash)

    unless is_nil(block) do
      transfers =
        Repo.all(
          from(t in Transfer, where: t.block_index == ^block.index, select: t.transaction_hash)
        )

      Map.put(block, :transfers, transfers)
    end
  end

  defp _get(hash) when is_binary(hash) do
    Repo.one(
      from(e in Block, where: e.hash == ^hash, preload: [transactions: ^transaction_query()])
    )
  end

  defp _get(index) when is_integer(index) do
    Repo.one(
      from(e in Block, where: e.index == ^index, preload: [transactions: ^transaction_query()])
    )
  end

  defp transaction_query do
    from(t in Transaction, select: t.hash)
  end

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
    max_index =
      Repo.one(
        from(
          b in Block,
          order_by: [
            desc: b.index
          ],
          limit: 1,
          select: b.index
        )
      )

    if is_nil(max_index), do: -1, else: max_index
  end

  def get_total_sys_fee(min, max) when max < min, do: []

  def get_total_sys_fee(min, max) do
    query =
      from(
        b in Block,
        where: b.index >= ^min and b.index <= ^max,
        select: map(b, [:index, :total_sys_fee]),
        order_by: :index
      )

    Repo.all(query)
  end
end
