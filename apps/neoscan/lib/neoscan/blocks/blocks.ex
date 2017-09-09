defmodule Neoscan.Blocks do
  @moduledoc false

  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Blocks.Block
  alias Neoscan.Transactions
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Addresses
  alias NeoscanMonitor.Api

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
  Returns the list of blocks in the home page.

  ## Examples

      iex> home_blocks()
      [%Block{}, ...]

  """
  def home_blocks do
    block_query = from e in Block,
      where: e.index > 1200000,
      order_by: [desc: e.index],
      select: %{:index => e.index, :time => e.time, :tx_count => e.tx_count, :hash => e.hash},
      limit: 15

    Repo.all(block_query)
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
   query = from e in Block,
     where: e.hash == ^hash,
     select: e
   Repo.all(query)
   |> List.first
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
    trans_query = from t in Transaction,
      select: %{
        type: t.type,
        txid: t.txid
      }
   query = from e in Block,
     where: e.hash == ^hash,
     preload: [transactions: ^trans_query],
     select: e
   Repo.all(query)
   |> List.first
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
   query = from e in Block,
     where: e.index == ^height,
     select: e
   Repo.all(query)
   |> List.first
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
  def update_blocks_state(block) do
    Api.add_block(block)
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
    |> Repo.update!()
  end

  @doc """
  Deletes a Block.

  ## Examples

      iex> delete_block(block)
      {:ok, %Block{}}

      iex> delete_block(block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_block(%Block{:updated_at => time} = block) do
    Addresses.rollback_addresses(time)
    Repo.delete!(block)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking block changes.

  ## Examples

      iex> change_block(block)
      %Ecto.Changeset{source: %Block{}}

  """
  def change_block(%Block{} = block) do
    Block.changeset(block, %{})
  end


  @doc """
  Returns the heighest block in the database

  ## Examples

      iex> get_highest_block_in_db()
      {:ok, %Block{}}

  """
  def get_highest_block_in_db() do
    query = from e in Block,
      select: e.index,
      where: e.index > 1200000,  #force postgres to use index
      order_by: [desc: e.index],
      limit: 1


    case Repo.all(query) do
      [index] ->
        {:ok , index}
      [] ->
        {:ok , -1 }
    end
  end

  @doc """
  get all blocks heigher than `height`

  ## Examples

      iex> get_higher_than(height)
      [%Block{}, ...]

  """
  def get_higher_than(index) do
    query = from e in Block,
      where: e.index > ^index,
      select: e
    Repo.all(query)
  end


  @doc """
  delete all blocks in list

  ## Examples

      iex> delete_blocks([%Block{}, ...])
      { :ok, "deleted"}

  """
  def delete_blocks([ block | tail ]), do: [ delete_block(block) | delete_blocks(tail)]
  def delete_blocks([]), do: {:ok , "Deleted" }

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

  def check_if_block_exists(hash, transaction) do
    query = from e in Block,
      where: e.hash == ^hash,
      select: e
    case Repo.all(query) |> List.first() do
      nil ->
        {:block_missing , transaction}
      block ->
        Transactions.check_if_transaction_exists(block, transaction)
        {:transaction_missing, {block, transaction}}
    end
  end

  def get_missing_blocks(transaction_tuples) do
    case Enum.any?(transaction_tuples, fn {key, _value} -> key == :block_missing end) do
      true ->
        Enum.filter(transaction_tuples, fn { key, _transaction} -> key == :block_missing end)
        |> Enum.group_by( fn { _key, transaction} -> transaction["blockhash"] end)
        |> Map.keys
        |> Enum.each(fn hash -> get_missing_block(hash) end)
      false ->
        :ok
    end
  end

  def get_missing_block(hash) do
    {:ok, block} = NeoscanSync.Blockchain.get_block_by_hash(NeoscanSync.HttpCalls.url(1), hash)
    NeoscanSync.Consumer.add_block(block)
  end


end
