defmodule Neoscan.Transactions do
  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo

  alias Neoscan.Transactions.Transaction
  alias Neoscan.Transactions.Vout

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Gets a single transaction by its hash value

  ## Examples

      iex> get_block_by_hash(123)
      %Block{}

      iex> get_block_by_hash(456)
      nil

  """
  def get_transaction_by_hash(hash) do
   query = from e in Transaction,
     where: e.txid == ^hash,
     left_join: v in assoc(e, :vouts),
     preload: [vouts: v]
   Repo.one(query)
   |> clean_vouts
  end
  def clean_vouts(transaction) do
    new_list = Enum.map(transaction.vouts, fn x -> apply(x) end)
    Map.put(transaction, :vouts, new_list)
  end
  def apply(%{:asset => asset, :address_hash => address, :value => value, :n => n }) do
    %{:asset => asset, :address_hash => address, :value => value, :n => n}
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(%{:time => time, :hash => hash, :index => height } = block, %{"vout" => vouts} = attrs \\ %{}) do
    transaction = Map.put(attrs,"time", time)
    |> Map.put("block_hash", hash)
    |> Map.put("block_height", height)
    |> Map.delete("vout")
    Transaction.changeset(block, transaction)
    |> Repo.insert!()
    |> create_vouts(vouts)
  end


  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  @doc """
  Creates many transactions.

  ## Examples

      iex> create_transactions([%{field: value}, ...])
      {:ok, "Created"}

      iex> create_transactions([%{field: value}, ...])
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(block, [transaction | tail]) do
    create_transaction(block, transaction)
    create_transactions(block, tail)
  end
  def create_transactions(_block, []), do: {:ok , "Created"}



  @doc """
  Creates a vout.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vout(transaction, attrs \\ %{}) do
    Vout.changeset(transaction, attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates many vouts.

  ## Examples

      iex> create_vouts([%{field: value}, ...])
      {:ok, "Created"}

      iex> create_vouts([%{field: value}, ...])
      {:error, %Ecto.Changeset{}}

  """
  def create_vouts(transaction, [vout | tail]) do
    create_vout(transaction, vout)
    create_vouts(transaction, tail)
  end
  def create_vouts(_block, []), do: {:ok , "Created"}
end
