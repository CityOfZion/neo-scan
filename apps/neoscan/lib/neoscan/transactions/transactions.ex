defmodule Neoscan.Transactions do

  @moduledoc false

  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias NeoscanMonitor.Api
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
      where: e.type != "MinerTransaction" and e.inserted_at > ago(1, "hour"),
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
     preload: [vouts: ^vout_query],
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
  def create_transaction(%{:time => time, :hash => hash, :index => height } = block, %{"vout" => vouts, "vin" => vin, "txid" => txid, "type" => type} = attrs) do

    #get vins and add to addresses
    new_vin = Task.async(fn -> get_vins(vin, txid) end)

    #get claims
    new_claim = Task.async(fn -> get_claims(attrs["claims"], vouts) end)

    #create asset if register Transaction
    assets(attrs["asset"], txid)

    #create asset if issue Transaction
    issue(type, vouts)

    #prepare and create transaction
    transaction = Map.merge(attrs, %{
          "time" => time,
          "vin" => Task.await(new_vin, 60*60000),
          "claims" => Task.await(new_claim, 60*60000),
          "block_hash" => hash,
          "block_height" => height,
    })
    |> Map.delete("vout")

    Transaction.changeset(block, transaction)
    |> Repo.insert!()
    |> update_transaction_state
    |> create_vouts(vouts)
  end
  def update_transaction_state(%{:type => type } = transaction) when type != "MinerTransaction" do
    Api.add_transaction(transaction)
    transaction
  end
  def update_transaction_state(%{:type => type } = transaction) when type == "PublishTransaction" or type == "InvocationTransaction" do
    Api.add_transaction(transaction)
    Api.add_contract(transaction)
    transaction
  end
  def update_transaction_state(transaction) do
    transaction
  end

  #get vins and add to addresses
  defp get_vins([] = vin, _txid) do
    vin
  end
  defp get_vins(vin, txid) do
    lookups = Stream.map(vin, &"#{&1["vout"]}#{&1["txid"]}")
    |> Enum.to_list

    query =  from e in Vout,
     where: fragment("CAST(? AS text) || ?", e.n, e.txid) in ^lookups,
     select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

    new_vin = Repo.all(query)

    Enum.group_by(new_vin, fn %{:address_hash => address} -> address end)
    |> Map.to_list()
    |> Addresses.populate_groups
    |> Stream.each(fn {address, vins} -> Addresses.insert_vins_in_address(address, vins, txid) end)
    |> Stream.run()

    new_vin
  end

  #get claimed vouts and add to addresses
  defp get_claims( nil = claims, _vouts) do
    claims
  end
  defp get_claims(claims, vouts) do
    Stream.map(claims, fn %{"txid" => txid } -> txid end)
    |> Stream.uniq()
    |> Enum.to_list
    |> Addresses.insert_claim_in_addresses(vouts)

    lookups = Stream.map(claims, &"#{&1["vout"]}#{&1["txid"]}")
    |> Enum.to_list

    query =  from e in Vout,
    where: fragment("CAST(? AS text) || ?", e.n, e.txid) in ^lookups,
    select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

    Repo.all(query)
  end

  #create new assets
  defp assets(%{"amount" => amount} = assets, txid) do
    {float, _} = Float.parse(amount)
    new_asset = Map.put(assets, "amount", float)
    create_asset(txid, new_asset)
  end
  defp assets( nil, _txid) do
    nil
  end

  #issue assets
  defp issue("IssueTransaction", vouts) do
    Stream.each(vouts, fn %{"asset" => asset_hash, "value" => value} ->
      {float, _} = Float.parse(value)
      add_issued_value(asset_hash, float)
    end)
    |> Stream.run()
  end
  defp issue(_type, _vouts) do
    nil
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
  def create_vout( transaction, attrs \\ %{}) do
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
    |> Enum.group_by(fn %{"address" => address} -> address.address end)
    |> Map.to_list()
    |> Stream.each(fn {_address, vouts} -> Addresses.insert_vouts_in_address(transaction, vouts) end)
    |> Stream.run()
  end

  #get vouts addresses
  def get_addresses(vouts) do
    lookups = Stream.map(vouts, &"#{&1["address"]}")
    |> Stream.uniq()
    |> Enum.to_list

    query =  from e in Address,
     where: fragment("CAST(? AS text)", e.address) in ^lookups,
     select: e

    Repo.all(query)
    |> fetch_missing(lookups)
    |> insert_address(vouts)
  end

  #create missing addresses
  def fetch_missing(address_list, lookups) do
    (lookups -- Enum.map(address_list, fn %{:address => address} -> address end))
    |> Stream.map(fn address -> Addresses.create_address(%{"address" => address}) end)
    |> Enum.to_list
    |> Enum.concat(address_list)
  end

  #insert address struct into vout
  def insert_address(address_list, vouts) do
    Stream.map(vouts, fn %{"address" => ad } = x ->
      Map.put(x, "address", Enum.find(address_list, fn %{ :address => address } -> address == ad end))
    end)
    |> Enum.to_list
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
    |> update_asset_state
  end
  def update_asset_state(asset) do
    Api.add_asset(asset)
    asset
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
   Repo.all(query)
   |> List.first
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
   Repo.all(query)
   |> List.first
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

  #add issued value to an existing asset
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
