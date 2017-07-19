defmodule Neoscan.Addresses do
  @moduledoc """
  The boundary for the Addresses system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo

  alias Neoscan.Addresses.Address

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    Repo.all(Address)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      %Address{}

      iex> create_address(%{field: bad_value})
      no_return

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      %Address{}

      iex> update_address(address, %{field: bad_value})
      no_return

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a Address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete!(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end

  @doc """
  Add transaction to address

  ## Examples

      iex> add_transaction(address, new_value})
      {:ok, %Address{}}

      iex> add_transaction(address, bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_transaction(%{:tx_ids => list} = address, transaction_id) do
    Map.put_new(address, :tx_ids, List.insert_at(list, 0, transaction_id))
    |> update_address(address)
  end

  @doc """
  Check if address exist in database

  ## Examples

      iex> check_if_exist(existing_address})
      true

      iex> check_if_exist(new_address})
      false

  """
  def check_if_exist(address) do
    query = from e in Address,
      where: e.address == ^address,
      select: e.addres

    case Repo.one(query) do
      nil ->
        false
      :string ->
        true
    end
  end


  @doc """
  Creates or updates an address with a transaction id and a transaction output

  ## Examples

      iex> check_if_exist(existing_address})
      true

      iex> check_if_exist(new_address})
      false

  """
  def create_or_update(address, transaction_id, vout) do
    case check_if_exist(address) do
        true ->
          add_transaction(address, transaction_id)
          |> add_vout(vout)
        false ->
          %{"address" => address}
          |> create_address()
          |> add_transaction(transaction_id)
          |> add_vout(vout)
    end
  end

  def add_vout(address, vout) do


  end



end
