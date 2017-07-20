defmodule Neoscan.Transactions do
  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo

  alias Neoscan.Transactions.Transaction
  alias Neoscan.Transactions.Vout
  alias Neoscan.Transactions.Asset
  alias Neoscan.Addresses

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
     where: e.txid == ^hash

   Repo.one(query)
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(%{:time => time, :hash => hash, :index => height } = block, %{"vout" => vouts, "vin" => vin} = attrs) do

    #get owner address and total amount sent
    new = cond do
       Kernel.length(vin) != 0 ->

         new_vin = Enum.map(vin, fn %{"txid" => txid, "vout" => vout_index} ->
           query = from e in Vout,
           where: e.txid == ^txid,
           where: e.n == ^vout_index

           Repo.one!(query)
         end)

         Enum.map(new_vin, fn vin -> Addresses.get_and_insert_vin(vin) end)
         Map.put(attrs, "vin", new_vin)
       true ->
         attrs
    end

    #create asset if issue Transaction
    cond do
      attrs["asset"] != nil ->
        %{"amount" => amount} = attrs["asset"]
        {float, _} = Float.parse(amount)
        new_asset = Map.put(attrs["asset"], "amount", float)
        create_asset(attrs["txid"], new_asset)
      true ->
        nil
    end



    #prepare and create transaction
    transaction = Map.put(new,"time", time)
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


  @doc """
  Creates an asset.

  ## Examples

      iex> create_asset(%{field: value})
      {:ok, %Asset{}}

      iex> create_asset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_asset(transaction_id, attrs) do
    Asset.changeset(transaction_id, attrs)
    |> Repo.insert!()
  end


end
