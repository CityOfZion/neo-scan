defmodule Neoscan.Blocks do
  @moduledoc false
  
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Blocks.Block

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
   query = from e in Block,
     where: e.index == ^height,
     select: e
   Repo.one(query)
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
  def delete_block(%Block{} = block) do
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
      order_by: [desc: e.index],
      limit: 1
    case Repo.all(query) do
      [block] ->
        {:ok , block}
      [] ->
        nil
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


end
