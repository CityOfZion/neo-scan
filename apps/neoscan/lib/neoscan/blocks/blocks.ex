defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Block
  alias Neoscan.BlockMeta
  alias Neoscan.Counters
  alias Neoscan.Transaction
  alias Neoscan.Transfer
  require Logger

  @page_size 15
  @missing_block_range 1_000

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
          from(t in Transfer, where: t.block_index == ^block.index, preload: [:transaction])
        )

      transfers =
        transfers
        |> Enum.filter(&(not is_nil(&1.transaction)))
        |> Enum.map(& &1.transaction.hash)

      Map.put(block, :transfers, transfers)
    end
  end

  defp _get(hash) when is_binary(hash) do
    Repo.one(
      from(
        e in Block,
        where: e.hash == ^hash,
        preload: [
          transactions: ^transaction_query()
        ]
      )
    )
  end

  defp _get(index) when is_integer(index) do
    Repo.one(
      from(
        e in Block,
        where: e.index == ^index,
        preload: [
          transactions: ^transaction_query()
        ]
      )
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
  def paginate(page), do: paginate(page, @page_size)

  def paginate(page, page_size) do
    block_query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        limit: ^page_size,
        select:
          merge(
            e,
            %{
              lag: fragment("extract(epoch FROM (? - lead(?) OVER ()))::integer", e.time, e.time)
            }
          )
      )

    Repo.paginate(block_query,
      page: page,
      page_size: page_size,
      options: [total_entries: Counters.count_blocks() || 0]
    )
  end

  def get_missing_block_indexes do
    query = """
      SELECT * FROM generate_series((SELECT GREATEST(0, (SELECT MAX(index) FROM blocks) - #{
      @missing_block_range - 1
    })),
        (SELECT MAX(index) FROM blocks)) as index
        EXCEPT SELECT * FROM (SELECT index FROM blocks ORDER BY index DESC LIMIT #{
      @missing_block_range
    }) as t(index)
    """

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

  def get_cumulative_fees(indexes) do
    max_query =
      from(
        b in Block,
        where: b.cumulative_sys_fee > 0.0,
        select: b.cumulative_sys_fee,
        order_by: [desc: :index],
        limit: 1
      )

    max = Repo.one(max_query) || Decimal.new(0.0)

    all_query =
      from(
        b in Block,
        where: b.index in ^indexes,
        select: map(b, [:index, :cumulative_sys_fee])
      )

    values = Repo.all(all_query)

    map =
      Map.new(values, fn %{index: index, cumulative_sys_fee: cumulative_sys_fee} ->
        {index, cumulative_sys_fee || max}
      end)

    map = Map.put(map, -1, Decimal.new(0.0))

    map = Enum.reduce(indexes, map, fn index, acc -> Map.put_new(acc, index, max) end)

    map
  end

  def last_index do
    Repo.one(from(c in BlockMeta, where: c.id == 1, select: c.index)) || 0
  end
end
