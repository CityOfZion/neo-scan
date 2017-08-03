defmodule Neoscan.Transactions do

  @moduledoc false

  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo

  alias Neoscan.Transactions.Transaction
  alias Neoscan.Transactions.Vout
  alias Neoscan.Transactions.Asset
  alias Neoscan.Addresses
  alias Neoscan.Addresses.Address

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
      order_by: [desc: e.inserted_at],
      where: e.type != "MinerTransaction",
      select: %{:type => e.type, :time => e.time, :txid => e.txid},
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
      order_by: [desc: e.inserted_at],
      where: e.type == "PublishTransaction" or e.type == "InvocationTransaction",
      select: %{:type => e.type, :time => e.time, :txid => e.txid}

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

   Repo.one(query)
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
     preload: [vouts: ^vout_query],
     select: e

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
    new_vin = Task.async(fn -> cond do
       Kernel.length(vin) != 0 ->

         lookups = Enum.map(vin, &"#{&1["vout"]}#{&1["txid"]}")

         query =  from e in Vout,
          where: fragment("CAST(? AS text) || ?", e.n, e.txid) in ^lookups,
          select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

         new_vin = Repo.all(query)

         Enum.group_by(new_vin, fn %{:address_hash => address} -> address end)
         |> Map.to_list()
         |> Enum.each(fn {address, vins} -> Addresses.insert_vins_in_address(address, vins) end)

         new_vin
       true ->
         vin
      end
    end)

    #get claims
    new_claim = Task.async( fn -> cond do
       attrs["claims"] != nil ->

         Enum.map(attrs["claims"], fn %{"txid" => txid } -> txid end)
         |> Enum.uniq()
         |> Addresses.insert_claim_in_addresses(vouts)

         lookups = Enum.map(attrs["claims"], &"#{&1["vout"]}#{&1["txid"]}")

         query =  from e in Vout,
          where: fragment("CAST(? AS text) || ?", e.n, e.txid) in ^lookups,
          select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

         Repo.all(query)

       true ->
         attrs["claims"]
      end
    end)

    #create asset if register Transaction
    cond do
      attrs["asset"] != nil ->
        %{"amount" => amount} = attrs["asset"]
        {float, _} = Float.parse(amount)
        new_asset = Map.put(attrs["asset"], "amount", float)
        create_asset(attrs["txid"], new_asset)
      true ->
        nil
    end

    #create asset if issue Transaction
    cond do
      attrs["type"] == "IssueTransaction" ->
        Enum.each(vouts, fn %{"asset" => asset_hash, "value" => value} ->
          {float, _} = Float.parse(value)
          add_issued_value(asset_hash, float)
        end)
      true ->
        nil
    end



    #prepare and create transaction

    transaction = Map.put(attrs,"time", time)
    |> Map.put("vin", Task.await(new_vin, 15000))
    |> Map.put("claims", Task.await(new_claim, 15000))
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
  def create_vouts( transaction, vouts) do
    vouts
    |> get_addresses()
    |> Enum.each(fn x-> create_vout(transaction, x) end)
  end

  def get_addresses(vouts) do
    lookups = Enum.map(vouts, &"#{&1["address"]}")
    |> Enum.uniq

    query =  from e in Address,
     where: fragment("CAST(? AS text)", e.address) in ^lookups,
     select: e

    Repo.all(query)
    |> fetch_missing(lookups)
    |> insert_address(vouts)
  end

  def fetch_missing(address_list, lookups) do
    lookups -- Enum.map(address_list, fn %{:address => address} -> address end)
    |> Enum.map(fn address -> Addresses.create_address(%{"address" => address}) end)
    |> Enum.concat(address_list)
  end

  def insert_address(address_list, vouts) do
    Enum.map(vouts, fn %{"address" => ad } = x ->
      Map.put(x, "address", Enum.find(address_list, fn %{ :address => address } -> address == ad end))
    end)
  end


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


  @doc """
  Gets asset  by its hash value

  ## Examples

      iex> get_asset_by_hash(hash)
      "NEO"

      iex> get_asset_by_hash(hash)
      "not found"

  """
  def get_asset_by_hash(hash) do
   query = from e in Asset,
     where: e.txid == ^hash
   Repo.one(query)
  end

  @doc """
  Gets asset name by its hash value

  ## Examples

      iex> get_asset_name_by_hash(hash)
      "NEO"

      iex> get_asset_name_by_hash(hash)
      "not found"

  """
  def get_asset_name_by_hash(hash) do
   query = from e in Asset,
     where: e.txid == ^hash,
     select: e.name
   Repo.one!(query)
   |>filter_name
  end

  def filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => name} -> cond do
          name == "AntShare" ->
            "NEO"
          name == "AntCoin" ->
            "GAS"
          true ->
            name
        end
      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end


  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def list_assets do
    query = from e in Asset,
    select: %{
      :hash => e.txid,
      :admin => e.admin,
      :amount => e.amount,
      :issued => e.issued,
      :type => e.type
    }
    Repo.all(query)
  end

  @doc """
  Updates an asset.

  ## Examples

      iex> update_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> update_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_asset(%Asset{} = asset, attrs) do
    asset
    |> Asset.update_changeset(attrs)
    |> Repo.update!()
  end

  def add_issued_value(asset_hash, value) do
    result = get_asset_by_hash(asset_hash)
    cond do
      result == nil ->
        IO.puts("Error issuing asset")
        {:error , "Non existant asset cant be issued!"}

      true ->
        attrs = %{"issued" => value}

        update_asset(result, attrs)
    end
  end


end
