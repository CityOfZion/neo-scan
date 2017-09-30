defmodule Neoscan.Transactions do

  @moduledoc false

  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias NeoscanMonitor.Api
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Vouts.Vout
  alias Neoscan.ChainAssets
  alias Neoscan.Addresses
  alias Neoscan.Vouts

  require Logger

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
  Returns the list of transactions in the home page.

  ## Examples

      iex> home_transactions()
      [%Transaction{}, ...]

  """
  def home_transactions do
    transaction_query = from e in Transaction,
                             order_by: [
                               desc: e.inserted_at
                             ],
                             where: e.inserted_at > ago(1, "hour") and e.type != "MinerTransaction",
                             select: %{
                               :type => e.type,
                               :time => e.time,
                               :txid => e.txid
                             },
                             limit: 15

    Repo.all(transaction_query)
  end

  @doc """
  Returns the list of contract transactions.

  ## Examples

      iex> list_contracts()
      [%Transaction{}, ...]

  """
  def list_contracts do
    transaction_query = from e in Transaction,
                             order_by: [
                               desc: e.inserted_at
                             ],
                             where: e.type == "PublishTransaction" or e.type == "InvocationTransaction",
                             select: %{
                               :type => e.type,
                               :time => e.time,
                               :txid => e.txid
                             }

    Repo.all(transaction_query)
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

    Repo.all(query)
    |> List.first
  end

  @doc """
  Gets a single transaction by its hash and send it as a map

  ## Examples

      iex> get_block_by_hash_for_view(123)
      %{}

      iex> get_block_by_hash_for_view(456)
      nil

  """
  def get_transaction_by_hash_for_view(hash) do
    vout_query = from v in Vout,
                      select: %{
                        asset: v.asset,
                        address_hash: v.address_hash,
                        value: v.value
                      }
    query = from e in Transaction,
                 where: e.txid == ^hash,
                 preload: [
                   vouts: ^vout_query
                 ],
                 select: e

    Repo.all(query)
    |> List.first
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(
        %{:time => time, :hash => hash, :index => height} = block,
        %{"vout" => vouts, "vin" => vin, "txid" => txid, "type" => type} = attrs
      ) do

    #get inputs from db
    new_vin = get_vins(vin, height)

    #get claims from db
    new_claim = get_claims(attrs["claims"])

    #fetch all addresses involved in the transaction
    address_list = Task.async(
      fn -> Addresses.get_transaction_addresses(new_vin, vouts, time)
            |> Addresses.update_all_addresses(
                 new_vin,
                 new_claim,
                 vouts,
                 String.slice(to_string(txid), -64..-1),
                 height,
                 time
               )
      end
    ) #updates addresses with vin and claims, vouts are just for record in claims, the balance is updated in the insert vout function called in create_vout

    #create asset if register Transaction
    ChainAssets.create(attrs["asset"], String.slice(to_string(txid), -64..-1), time)

    #create asset if issue Transaction
    ChainAssets.issue(type, vouts)

    #prepare and create transaction
    transaction = Map.merge(
                    attrs,
                    %{
                      "txid" => String.slice(to_string(txid), -64..-1),
                      "time" => time,
                      "vin" => new_vin,
                      "claims" => new_claim,
                      "block_hash" => hash,
                      "block_height" => height,
                    }
                  )
                  |> Map.delete("vout")

    Transaction.changeset_with_block(block, transaction)
    |> Repo.insert!()
    |> update_transaction_state
    |> Vouts.create_vouts(vouts, Task.await(address_list, 60000))
  end

  #add transaction to monitor cache
  def update_transaction_state(%{:type => type} = transaction) when type != "MinerTransaction" do
    Api.add_transaction(transaction)
    transaction
  end
  def update_transaction_state(%{:type => type} = transaction)
      when type == "PublishTransaction" or type == "InvocationTransaction" do
    Api.add_transaction(transaction)
    Api.add_contract(transaction)
    transaction
  end
  def update_transaction_state(transaction) do
    transaction
  end

  #get vins and add to addresses
  defp get_vins([] = vin, _height) do
    vin
  end
  defp get_vins(vin, height) do
    lookups = Enum.map(
      vin,
      &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}"
    ) #sometimes "0x" is prepended to hashes

    query = from e in Vout,
                 where: e.query in ^lookups,
                 select: struct(e, [:asset, :address_hash, :n, :value, :txid, :query, :id])

    Repo.all(query)
    |> Vouts.verify_vouts(lookups, vin)
    |> Vouts.end_vouts_and_return(height)
  end

  #get claimed vouts and add to addresses
  defp get_claims(nil = claims) do
    claims
  end
  defp get_claims(claims) do

    lookups = Enum.map(
      claims,
      &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}"
    ) #sometimes "0x" is prepended to hashes

    query = from e in Vout,
                 where: e.query in ^lookups,
                 select: struct(e, [:asset, :address_hash, :n, :value, :txid, :query, :id])

    Repo.all(query)
    |> Vouts.verify_vouts(lookups, claims)
    |> Vouts.set_claimed_and_return()
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
    |> Transaction.update_changeset(attrs)
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
  Creates many transactions.

  ## Examples

      iex> create_transactions([%{field: value}, ...])
      {:ok, "Created"}

      iex> create_transactions([%{field: value}, ...])
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(block, transactions) do
    case Enum.each(transactions, fn transaction -> create_transaction(block, transaction) end) do
      :ok ->
        {:ok, "Created"}
      _ ->
        {:error, "failed to create transactions"}
    end
  end

end
