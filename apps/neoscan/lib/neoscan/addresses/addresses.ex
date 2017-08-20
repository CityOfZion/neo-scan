defmodule Neoscan.Addresses do
  @moduledoc false
  @moduledoc """
  The boundary for the Addresses system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Addresses.Address
  alias Neoscan.Transactions

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
  Gets a single address by its hash and send it as a map

  ## Examples

      iex> get_address_by_hash_for_view(123)
      %{}

      iex> get_address_by_hash_for_view(456)
      nil

  """
  def get_address_by_hash_for_view(hash) do
   query = from e in Address,
     where: e.address == ^hash,
     select: %{:address => e.address, :tx_ids => e.tx_ids, :balance => e.balance, :claimed => e.claimed}
   Repo.all(query)
   |> List.first
  end


  @doc """
  Gets a single address by its hash and send it as a map

  ## Examples

      iex> get_address_by_hash(123)
      %{}

      iex> get_address_by_hash(456)
      nil

  """
  def get_address_by_hash(hash) do

   query = from e in Address,
     where: e.address == ^hash,
     select: e

   Repo.all(query)
   |> List.first
  end

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

    case Repo.all(query) |> List.first do
      nil ->
        false
      :string ->
        true
    end
  end

  @doc """
  Populates tuples {address_hash, vins} with {%Adddress{}, vins}

  ## Examples

      iex> populate_groups(groups})
      [{%Address{}, _},...]


  """
  def populate_groups(groups) do
    lookups = groups
      |> Stream.map(fn {address, _ } -> address end)
      |> Enum.to_list

    query =  from e in Address,
     where: fragment("CAST(? AS text)", e.address) in ^lookups,
     select: e

    address_list = Repo.all(query)

    Stream.map(groups, fn {address, vins} -> {Enum.find(address_list, fn %{:address => ad} -> ad == address end), vins} end)
    |> Enum.to_list
  end


  #insert vouts into address balance
  def insert_vouts_in_address(%{:txid => txid} = transaction, vouts) do
    %{"address" => address } = List.first(vouts)
    attrs = %{:balance => address.balance , :tx_ids => address.tx_ids}
    |> add_vouts(vouts, transaction)
    |> add_tx_id(txid)
    update_address(address, attrs)
  end

  #insert vins into address balance
  def insert_vins_in_address(address, vins, txid) do
    attrs = %{:balance => address.balance, :tx_ids => address.tx_ids}
    |> add_vins(vins)
    |> add_tx_id(txid)
    update_address(address, attrs)
  end

  #add multiple vins
  def add_vins(attrs, [h | t]) do
    add_vin(attrs, h)
    |> add_vins(t)
  end
  def add_vins(attrs, []), do: attrs

  #add multiple vouts
  def add_vouts(attrs, [h | t], transaction) do
    Transactions.create_vout(transaction, h)
    |> add_vout(attrs)
    |> add_vouts(t, transaction)
  end
  def add_vouts(attrs, [], _transaction), do: attrs

  #get addresses and route for adding claims
  def insert_claim_in_addresses(transactions, vouts) do
    lookups = Stream.map(vouts, &"#{&1["address"]}")
      |> Stream.uniq
      |> Enum.to_list

    query =  from e in Address,
     where: fragment("CAST(? AS text)", e.address) in ^lookups,
     select: e

    address_list = Repo.all(query)

    Stream.each(vouts, fn %{"address" => hash, "value" => value, "asset" => asset} ->
      insert_claim_in_address(Enum.find(address_list, fn %{:address => address} -> address == hash end) , transactions, value, asset, hash)
    end)
    |> Enum.to_list
  end

  #insert claimed transactions and update address balance
  def insert_claim_in_address(nil, transactions, value, asset, address_hash) do
    attrs = %{:address => address_hash, :claimed => nil}
    |> add_claim(transactions, value, asset)

    create_address(attrs)
  end
  def insert_claim_in_address(address, transactions, value, asset, _address_hash) do
    attrs = %{:claimed => address.claimed}
    |> add_claim(transactions, value, asset)

    update_address(address, attrs)
  end

  #add a single vout into adress
  def add_vout(%{:value => value} = vout, %{:balance => balance} = address) do
    current_amount = balance[vout.asset]["amount"] || 0
    new_balance = %{"asset" => vout.asset, "amount" => current_amount + value}
    %{address | balance: Map.put(address.balance || %{}, vout.asset, new_balance)}
  end

  #add a single vin into adress
  def add_vin(%{:balance => balance} = attrs, vin) do
    current_amount = balance[vin.asset]["amount"]
    new_balance = %{"asset" => vin.asset, "amount" => current_amount - vin.value}
    %{attrs | balance: Map.put(attrs.balance || %{}, vin.asset, new_balance)}
  end

  #add a transaction id into address
  def add_tx_id(address, txid) do
      new_tx = %{"txid" => txid, "balance" => address.balance}
      %{address | tx_ids: Map.put(address.tx_ids || %{}, txid, new_tx)}
  end

  #add a single claim into address
  def add_claim(%{:claimed => nil} = address, transactions, amount, asset) do
    Map.put(address, :claimed, [%{ "txids" => transactions, "amount" => amount, "asset" => asset}])
  end
  def add_claim(address, transactions, amount, asset) do
    case Enum.member?(address.claimed, %{ "txids" => transactions}) do
      true ->
        address
      false ->
        new = List.wrap(%{ "txids" => transactions, "amount" => amount, "asset" => asset})
        Map.put(address, :claimed, Enum.concat(address.claimed, new))
    end
  end

  #rollback addresses to specific insertion time
  def rollback_addresses(time) do
    query = from a in Address,
      where: a.updated_at > time,
      select: a

    Repo.all(query)
    |> route_if_results
  end

  def route_if_results([] = list), do: "no results"
  def route_if_results(list) do
    list
    |> Stream.each(fn a -> rollback_address(a, time) end)
    |> Enum.to_list  
  end

  #rollback address to a previous insertion time
  def rollback_address(address, time) do
    transactions_time = get_address_transactions_time(address)

    invalid_transactions = transactions_time
      |> Stream.filter(fn %{ "time" => txtime} -> txtime > time end)
      |> Stream.map(fn %{ "txid" => txid} -> txid end)
      |> Enum.to_list

    last_valid = transactions_time
      |> Stream.filter(fn %{ "time" => txtime} -> txtime < time end)
      |> Enum.to_list
      |> Enum.max_by(fn %{"time" => txtime} -> txtime end)

    new_tx_ids = remove_transactions(address.tx_ids, invalid_transactions)
    new_balance = address.tx_ids[last_valid]["balance"]

    update_address(address, %{"tx_ids" => new_tx_ids, "balance" => new_balance})
  end

  #get transaction times for an address
  def get_address_transactions_time(address) do
    lookups = Map.keys(address.tx_ids)

    query =  from t in Transactions,
     where: fragment("CAST(? AS text)", t.txid) in ^lookups,
     select: %{"txid" => t.txid, "time" => t.inserted_at}

    Repo.all(query)
  end

  #remove transactions from an address struct
  def remove_transactions(address_tx_ids, [transaction | tail]) do
    remove_transaction(address_tx_ids, transaction)
    |> remove_transactions(tail)
  end
  def remove_transactions(address_tx_ids, []), do: address

  #remove transaction from an address struct
  def remove_transaction(address_tx_ids, transaction) do
    Map.delete(address.tx_ids, transaction)
  end
end
