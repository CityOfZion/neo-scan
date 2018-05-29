defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Transfers
  alias Neoscan.Transactions
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Stats
  alias NeoscanNode.Blockchain
  require Logger

  @doc """
  Returns the list of blocks.

  ## Examples

      iex> list_blocks()
      [%Block{}, ...]

  """
  def list_blocks do
    Repo.all(Block)
  end

  @doc """
  Count total blocks in DB.

  ## Examples

      iex> count_blocks()
      50

  """
  def count_blocks do
    Repo.aggregate(Block, :count, :id)
  end

  @doc """
  Returns the list of blocks in the home page.

  ## Examples

      iex> home_blocks()
      [%Block{}, ...]

  """
  def home_blocks do
    block_query =
      from(
        e in Block,
        where: e.index > -1,
        order_by: [
          desc: e.id
        ],
        select: %{
          :index => e.index,
          :time => e.time,
          :tx_count => e.tx_count,
          :hash => e.hash,
          :size => e.size
        },
        limit: 15
      )

    Repo.all(block_query)
  end

  @doc """
  Returns the list of paginated blocks.

  ## Examples

      iex> paginate_blocks(page)
      [%Block{}, ...]

  """
  def paginate_blocks(pag) do
    block_query =
      from(
        e in Block,
        where: e.index > -1,
        order_by: [
          desc: e.id
        ],
        select: %{
          :index => e.index,
          :time => e.time,
          :tx_count => e.tx_count,
          :hash => e.hash,
          :size => e.size
        },
        limit: 15
      )

    Repo.paginate(block_query, page: pag, page_size: 15)
  end

  @doc """
  Gets a single block.

  Raises `Ecto.NoResultsError` if the Block does not exist.

  ## Examples

      iex> get_block!(123)
      %Block{}

      iex> get_block!(456)
      ** (Ecto.NoResultsError)

  """
  def get_block!(id), do: Repo.get!(Block, id)

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
        where: e.hash == ^hash,
        select: e
      )

    Repo.all(query)
    |> List.first()
  end

  @doc """
  Gets a single block by its hash value for blocks page

  ## Examples

      iex> get_block_by_hash_for_view(hash)
      %Block{}

      iex> get_block_by_hash_for_view(hash)
      nil

  """
  def get_block_by_hash_for_view(hash) do
    trans_query =
      from(
        t in Transaction,
        select: %{
          type: t.type,
          txid: t.txid
        }
      )

    query =
      from(
        e in Block,
        where: e.hash == ^hash,
        preload: [
          transactions: ^trans_query
        ],
        select: e
      )

    Repo.all(query)
    |> List.first()
  end

  @doc """
  Gets a single block by its hash value for blocks page, with paginated transactions

  ## Examples

      iex> paginate_transactions(hash, page)
      %Block{}

      iex> paginate_transactions(hash, page)
      nil

  """
  def paginate_transactions(hash, page) do
    query =
      from(
        e in Block,
        where: e.hash == ^hash,
        select: e
      )

    block =
      Repo.all(query)
      |> List.first()

    transactions = Transactions.paginate_transactions_for_block(block.id, page)

    {block, transactions}
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
        where: e.index == ^height,
        select: e
      )

    Repo.all(query)
    |> List.first()
  end

  @doc """
  Get the block time by its heigh value

  ## Examples

      iex> get_block_time(123)
      12518982

      iex> get_block_time(456)
      nill

  """
  def get_block_time(height) do
    case Blockchain.get_block_by_height(height) do
      {:ok, block} ->
        Map.get(block, "time")

      _ ->
        get_block_time(height)
    end
  end

  @doc """
  Creates a block.

  ## Examples

      iex> create_block(%{field: value})
      {:ok, %Block{}}

      iex> create_block(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_block(attrs \\ %{}) do
    %Block{}
    |> Block.changeset(attrs)
    |> Repo.insert!()
    |> update_blocks_state
  end

  defp update_blocks_state(block) do
    Stats.add_block_to_table()
    block
  end

  @doc """
  Updates a block.

  ## Examples

      iex> update_block(block, %{field: new_value})
      {:ok, %Block{}}

      iex> update_block(block, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_block(%Block{} = block, attrs) do
    block
    |> Block.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Block.

  ## Examples

      iex> delete_block(block)
      {:ok, %Block{}}

      iex> delete_block(block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_block(%Block{:updated_at => _time} = block) do
    # Addresses.rollback_addresses(time) TODO
    Repo.delete!(block)
  end

  @doc """
  Returns the heighest block in the database

  ## Examples

      iex> get_highest_block_in_db()
      {:ok, %Block{}}

  """
  def get_highest_block_in_db do
    query =
      from(
        e in Block,
        select: e.index,
        where: e.index > -1,
        order_by: [fragment("? DESC NULLS LAST", e.index)],
        limit: 1
      )

    case Repo.all(query) do
      [index] ->
        {:ok, index}

      [] ->
        {:ok, -1}
    end
  end

  @doc """
  get all blocks heigher than `height`

  ## Examples

      iex> get_higher_than(height)
      [%Block{}, ...]

  """
  def get_higher_than(index) do
    query =
      from(
        e in Block,
        where: e.index > ^index,
        select: e
      )

    Repo.all(query)
  end

  @doc """
  delete all blocks in list

  ## Examples

      iex> delete_blocks([%Block{}, ...])
      { :ok, "deleted"}

  """
  def delete_blocks([block | tail]), do: [delete_block(block) | delete_blocks(tail)]
  def delete_blocks([]), do: []

  @doc """
  delete all blocks heigher than `height`

  ## Examples

      iex> get_higher_than(height)
      [%Block{}, ...]

  """
  def delete_higher_than(height) do
    get_higher_than(height)
    |> delete_blocks
  end

  # get the total of spent fees in the network between a height range
  def get_fees_in_range(height1, height2) do
    value1 = String.to_integer(height1)

    try do
      String.to_integer(height2)
    rescue
      ArgumentError ->
        "wrong input"
    else
      value2 ->
        range = [value1, value2]

        max = Enum.max(range)
        min = Enum.min(range)

        query =
          from(
            b in Block,
            where: b.index >= ^min and b.index < ^max,
            select: %{
              :total_sys_fee => b.total_sys_fee,
              :total_net_fee => b.total_net_fee
            }
          )

        Repo.all(query)
        |> Enum.reduce(%{:total_sys_fee => 0, :total_net_fee => 0}, fn %{
                                                                         :total_sys_fee =>
                                                                           sys_fee,
                                                                         :total_net_fee => net_fee
                                                                       },
                                                                       acc ->
          %{
            :total_sys_fee => acc.total_sys_fee + sys_fee,
            :total_net_fee => acc.total_net_fee + net_fee
          }
        end)
    end
  rescue
    ArgumentError ->
      "wrong input string can't be parsed into integer"
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

  def compute_fees(block) do
    sys_fee =
      Enum.reduce(block["tx"], 0, fn tx, acc ->
        case Float.parse(tx["sys_fee"]) do
          {num, _st} ->
            acc + num

          :error ->
            acc + 0
        end
      end)

    net_fee =
      Enum.reduce(block["tx"], 0, fn tx, acc ->
        case Float.parse(tx["net_fee"]) do
          {num, _st} ->
            acc + num

          :error ->
            acc + 0
        end
      end)

    Map.merge(block, %{"total_sys_fee" => sys_fee, "total_net_fee" => net_fee})
  end

  # add block with transactions to the db
  def add_block(
        %{
          "tx" => transactions,
          "index" => height,
          "time" => time,
          "transfers" => tf
        } = block
      ) do
    Map.put(block, "tx_count", Kernel.length(transactions))
    |> compute_fees()
    |> Map.delete("tx")
    |> Map.delete("transfers")
    |> create_block()
    |> Transactions.create_transactions(transactions)
    |> check(tf, height)
    |> Transfers.add_block_transfers(time)
    |> check_final(height)
  end

  defp check({:ok, "Created", block}, transfers, _height) do
    {block, transfers}
  end

  defp check({:ok, "Deleted", block}, transfers, _height) do
    {block, transfers}
  end

  defp check(_, _transfers, height) do
    Logger.info("Failed to create transactions")
    delete_block(get_block_by_height(height))
  end

  defp check_final({:ok, "all operations were succesfull"}, height) do
    Logger.info("Block #{height} stored")
  end

  defp check_final(_, height) do
    Logger.info("Failed to create transactions")
    delete_block(get_block_by_height(height))
  end
end
