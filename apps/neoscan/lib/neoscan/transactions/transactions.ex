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
  alias Neoscan.Blocks

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
      where: e.inserted_at > ago(1, "hour") and  e.type != "MinerTransaction",
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
  def create_transaction(%{:time => time, :hash => hash, :index => index } = block, %{"vout" => vouts, "vin" => vin, "txid" => txid, "type" => type} = attrs) do

    #get inputs from db
    new_vin = get_vins(vin)

    #get claims from db
    new_claim = get_claims(attrs["claims"])

    #fetch all addresses involved in the transaction
    address_list = Task.async(fn -> Addresses.get_transaction_addresses( new_vin, vouts )
    |> Addresses.update_all_addresses(new_vin, new_claim, vouts, String.slice(to_string(txid), -64..-1), index) end) #updates addresses with vin and claims, vouts are just for record in claims, the balance is updated in the insert vout function called in create_vout

    #create asset if register Transaction
    assets(attrs["asset"], String.slice(to_string(txid), -64..-1))

    #create asset if issue Transaction
    issue(type, vouts)

    #prepare and create transaction
    transaction = Map.merge(attrs, %{
          "txid" => String.slice(to_string(txid), -64..-1),
          "time" => time,
          "vin" => new_vin,
          "claims" => new_claim,
          "block_hash" => hash,
          "block_height" => index,
    })
    |> Map.delete("vout")

    Transaction.changeset(block, transaction)
    |> Repo.insert!()
    |> update_transaction_state
    |> create_vouts(vouts, Task.await(address_list, 60000))
  end

  #add transaction to monitor cache
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
  defp get_vins([] = vin) do
    vin
  end
  defp get_vins(vin) do
    lookups = Enum.map(vin, &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}") #sometimes "0x" is prepended to hashes

    query =  from e in Vout,
     where: e.query in ^lookups,
     select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

    Repo.all(query)
    |> verify_vouts(lookups, vin)
  end

  #get claimed vouts and add to addresses
  defp get_claims( nil = claims) do
    claims
  end
  defp get_claims(claims) do

    lookups = Enum.map(claims, &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}") #sometimes "0x" is prepended to hashes

    query =  from e in Vout,
    where: e.query in ^lookups,
    select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

    Repo.all(query)
    |> verify_vouts(lookups, claims)
  end

  #check if all vouts were found
  def verify_vouts(result, lookups, root) do
    cond do
      Enum.count(result) == Enum.count(lookups) ->
        result
      true ->
        repair_missing(result, root)
    end
  end

  #trigger repair if information is missing
  def repair_missing( [], root) do
    missing = Enum.map(root, fn %{"txid" => txid} -> String.slice(to_string(txid), -64..-1) end)
    get_missing(missing, root)
  end
  #trigger repair if information is missing
  def repair_missing(result, root) do
    missing = Enum.map(root, fn %{"txid" => txid} -> String.slice(to_string(txid), -64..-1) end) -- Enum.map(result, fn %{:txid => txid} -> txid end)
    get_missing(missing, root)
  end

  #get missing information
  def get_missing(missing, root) do
    tuples = Enum.map(missing, fn txid -> NeoscanSync.Blockchain.get_transaction( NeoscanSync.HttpCalls.url(1), txid) end)
    |> check_missing()

    Blocks.get_missing_blocks(tuples)
    |> add_missing_transactions(tuples)
    |> add_missing_vouts(tuples)
    |> fetch_missing_vouts(root)
  end

  def check_missing(transactions) do
    Enum.map(transactions, fn {:ok, %{"blockhash" => block_hash} = transaction } -> Blocks.check_if_block_exists(String.slice(to_string(block_hash), -64..-1), transaction) end)
  end

  #fetch vouts again after repairing
  def fetch_missing_vouts(_result , root) do
    lookups = Enum.map(root, &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}") #sometimes "0x" is prepended to hashes

    query =  from e in Vout,
    where: e.query in ^lookups,
    select: %{:asset => e.asset, :address_hash => e.address_hash, :n => e.n, :value => e.value, :txid => e.txid}

    Repo.all(query)
    |> verify_vouts(lookups, root)
  end

  def check_if_transaction_exists(block, transaction) do
    txid = String.slice(to_string(transaction["txid"]), -64..-1)
    query = from t in Transaction,
      where: t.txid == ^txid,
      select: t
    case Repo.all(query) |> List.first() do
      nil ->
        {:transaction_missing , {block, transaction}}
      db_transaction ->
        check_if_vouts_exists(db_transaction, transaction)
    end
  end

  def check_if_vouts_exists(db_transaction, transaction) do
    query = from v in Vout,
      where: v.transaction_id == ^db_transaction.id,
      select: v

    db_vouts = Repo.all(query)

    missing = cond do
      db_vouts == [] ->
        Enum.map(transaction["vout"], fn %{"n"=> n} -> n end)
      true ->
        Enum.map(transaction["vout"], fn %{"n"=> n} -> n end) -- Enum.map(db_vouts, fn %{:n => n} -> n end)
    end

    {:vouts_missing, {db_transaction, Enum.filter(transaction["vout"], fn %{"n" => n} -> n in missing end)}}
  end

  #adds missing transactions after verifying missing blocks
  def add_missing_transactions(:ok, tuples) do
    case Enum.any?(tuples, fn {key, _value} -> key == :transaction_missing end) do
      true ->
        Enum.filter(tuples, fn { key, _tuple} -> key == :transaction_missing end)
        |> Enum.map(fn {_key, {block, transaction}} -> {block, transaction} end)
        |> Enum.group_by(fn {block, _transaction} -> block end)
        |> Map.to_list
        |> Enum.map(fn {block, transaction_tuples} -> { block, filter_tuples(transaction_tuples) } end)
        |> Enum.map(fn {block, transaction_list} -> create_transactions(block, transaction_list) end)
        |> Enum.uniq
      false ->
        [{:ok, "Created"}]
    end

  end
  def add_missing_transactions( _, _tuples) do
    raise "error fetching and adding missing blocks"
  end

  #adds missing vouts after verifying missing blocks and transactions
  def add_missing_vouts( list, tuples) when list == [{:ok, "Created"}] do
    Enum.filter(tuples, fn { key, _tuple} -> key == :vouts_missing end)
    |> Enum.map(fn {_key, {db_transaction, vouts}} -> {db_transaction, vouts} end)
    |> Enum.group_by(fn {db_transaction, _transaction} -> db_transaction end)
    |> Map.to_list
    |> Enum.map(fn {db_transaction, vouts_tuple} -> { db_transaction, filter_tuples(vouts_tuple) } end)
    |> Enum.map(fn {db_transaction, vouts} ->
      address_list = Addresses.get_transaction_addresses([], vouts)
      create_vouts(db_transaction, vouts, address_list)
    end)
  end
  def add_missing_vouts( _, _tuples) do
    raise "error fetching and adding missing transactions"
  end


  def filter_tuples(tuples) do
    Enum.map(tuples, fn {_block, content} -> content end)
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
    Enum.each(vouts, fn %{"asset" => asset_hash, "value" => value} ->
      {float, _} = Float.parse(value)
      add_issued_value(String.slice(to_string(asset_hash), -64..-1), float)
    end)
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
  def create_transactions(block, transactions) do
    case Enum.each(transactions, fn transaction -> create_transaction(block, transaction) end) do
      :ok ->
        {:ok , "Created"}
      _ ->
        {:error, "failed to create transactions"}
    end
  end



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
  def create_vouts( transaction, vouts, address_list) do
    vouts
    |> insert_address(address_list)
    |> Enum.group_by(fn %{"address" => {address , _attrs}} -> address.address end)
    |> Map.to_list()
    |> Enum.map(fn {_address, vouts} -> Addresses.insert_vouts_in_address(transaction, vouts) end)
    |> Addresses.update_multiple_addresses()
  end


  #insert address struct into vout
  def insert_address(vouts, address_list) do
    Enum.map(vouts, fn %{"address" => ad } = x ->
      Map.put(x, "address", Enum.find(address_list, fn {%{ :address => address }, _attrs} -> address == ad end))
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
      :txid => e.txid,
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
