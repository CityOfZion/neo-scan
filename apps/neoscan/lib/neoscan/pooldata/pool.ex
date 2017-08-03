defmodule Neoscan.Pool do
  @moduledoc false
  @moduledoc """
  The boundary for the dataes system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Pool.Data

  @doc """
  Returns the list of data.

  ## Examples

      iex> list_data()
      [%data{}, ...]

  """
  def list_data do
    Repo.all(Data)
  end

  @doc """
  Gets a single data block.

  Raises `Ecto.NoResultsError` if the data does not exist.

  ## Examples

      iex> get_data!(123)
      %data{}

      iex> get_data!(456)
      ** (Ecto.NoResultsError)

  """
  def get_data!(id), do: Repo.get!(Data, id)

  @doc """
  Creates a data.

  ## Examples

      iex> create_data(%{field: value})
      %data{}

      iex> create_data(%{field: bad_value})
      no_return

  """
  def create_data(attrs \\ %{}) do
    %Data{}
    |> Data.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a data.

  ## Examples

      iex> update_data(data, %{field: new_value})
      %data{}

      iex> update_data(data, %{field: bad_value})
      no_return

  """
  def update_data(%Data{} = data, attrs) do
    data
    |> data.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a data.

  ## Examples

      iex> delete_data(data)
      {:ok, %data{}}

      iex> delete_data(data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_data(%Data{} = data) do
    Repo.delete!(data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking data changes.

  ## Examples

      iex> change_data(data)
      %Ecto.Changeset{source: %data{}}

  """
  def change_data(%Data{} = data) do
    data.changeset(data, %{})
  end

  @doc """
  Returns the height of the heighest block in pool

  ## Examples

      iex> get_highest_block_in_pool()
      {:ok, %Data{}}

  """
  def get_highest_block_in_pool() do
    query = from e in Data,
      order_by: [desc: e.height],
      limit: 1,
      select: e.height
    case Repo.all(query) |> List.first do
       x when is_integer(x) ->
        x
      nil ->
        -1
    end
  end

  @doc """
  Returns block from the pool

  ## Examples

      iex> get_block_in_pool(height)
      block

  """
  def get_block_in_pool(height) do
    query = from e in Data,
      where: e.height == ^height,
      limit: 1,
      select: e.block
    Repo.all(query)
    |> List.first
  end

end
