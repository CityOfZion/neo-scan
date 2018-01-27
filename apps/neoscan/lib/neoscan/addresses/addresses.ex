defmodule Neoscan.Addresses do
  @moduledoc """
  The boundary for the Addresses system.
  """

  import Ecto.Query, warn: false

  require Logger

  alias Neoscan.Repo
  alias Neoscan.Addresses.Address
  alias Neoscan.BalanceHistories
  alias Neoscan.BalanceHistories.History
  alias Neoscan.Claims
  alias Neoscan.Claims.Claim
  alias Neoscan.Transfers
  alias Neoscan.Helpers
  alias Neoscan.Stats
  alias Ecto.Multi

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    from(a in Address, preload: :histories)
    |> Repo.all()
  end

  @doc """
  Returns a list of the latest updated addresses.

  ## Examples

      iex> list_latest()
      [%Address{}, ...]

  """
  def list_latest do
    query =
      from(
        a in Address,
        order_by: [
          desc: a.updated_at
        ],
        select: %{
          :address => a.address,
          :balance => a.balance,
          :time => a.time,
          :tx_count => a.tx_count
        },
        limit: 15
      )

    Repo.all(query)
  end

  @doc """
  Count total addresses in DB.

  ## Examples

      iex> count_addresses()
      50

  """
  def count_addresses do
    Repo.aggregate(Address, :count, :id)
  end

  @doc """
  Returns the list of paginated addresses.

  ## Examples

      iex> paginate_addresses(page)
      [%Address{}, ...]

  """
  def paginate_addresses(pag) do
    addresses_query =
      from(
        e in Address,
        order_by: [
          desc: e.updated_at
        ],
        select: %{
          :address => e.address,
          :balance => e.balance,
          :time => e.time,
          :tx_count => e.tx_count
        },
        limit: 15
      )

    Repo.paginate(addresses_query, page: pag, page_size: 15)
  end

  @doc """
  Count total addresses in DB that have an especific asset.

  ## Examples

      iex> count_addresses_for_asset()
      20

  """
  def count_addresses_for_asset(asset_hash) do
    query = from(a in Address, where: fragment("? \\? ?", a.balance, ^asset_hash))

    Repo.aggregate(query, :count, :balance)
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
  def get_address!(id) do
    from(a in Address, where: a.id == ^id, preload: :histories)
    |> Repo.all()
  end

  @doc """
  Gets a single address by its hash and send it as a map

  ## Examples

      iex> get_address_by_hash_for_view(123)
      %{}

      iex> get_address_by_hash_for_view(456)
      nil

  """
  def get_address_by_hash_for_view(hash) do
    query =
      from(
        e in Address,
        where: e.address == ^hash,
        select: e
      )

    # %{:address => e.address, :tx_ids => e.histories,
    #  :balance => e.balance, :claimed => e.claimed}
    Repo.all(query)
    |> List.first()
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
    query =
      from(
        e in Address,
        where: e.address == ^hash,
        select: e
      )

    Repo.all(query)
    |> List.first()
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
    Stats.add_address_to_table()

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
    |> Address.update_changeset(attrs)
    |> Repo.update()
  end

  # updates all addresses in the transactions with their
  # respective changes/inserts
  def update_multiple_addresses(list) do
    list
    |> Enum.map(fn {address, attrs} ->
      verify_if_claim_and_call_changesets(address, attrs)
    end)
    |> create_multi
    |> Repo.transaction()
    |> check_repo_transaction_results()
  end

  # verify if there was claim operations for the address
  def verify_if_claim_and_call_changesets(
        address,
        %{:claimed => claim} = attrs
      ) do
    {
      address,
      Claims.change_claim(%Claim{}, address, claim),
      BalanceHistories.change_history(%History{}, address, attrs.tx_ids),
      change_address(address, attrs)
    }
  end

  def verify_if_claim_and_call_changesets(address, attrs) do
    {
      address,
      nil,
      BalanceHistories.change_history(%History{}, address, attrs.tx_ids),
      change_address(address, attrs)
    }
  end

  # creates new Ecto.Multi sequence for single DB transaction
  def create_multi(changesets) do
    Enum.reduce(changesets, Multi.new(), fn tuple, acc -> insert_updates(tuple, acc) end)
  end

  # Insert address updates in the Ecto.Multi
  def insert_updates(
        {address, claim_changeset, history_changeset, address_changeset},
        acc
      ) do
    name = String.to_atom(address.address)
    name1 = String.to_atom("#{address.address}_history")
    name2 = String.to_atom("#{address.address}_claim")

    acc
    |> Multi.update(name, address_changeset, [])
    |> Multi.insert(name1, history_changeset, [])
    |> Claims.add_claim_if_claim(name2, claim_changeset)
  end

  # verify if DB transaction was sucessfull
  def check_repo_transaction_results({:ok, _any}) do
    {:ok, "all operations were succesfull"}
  end

  def check_repo_transaction_results({:error, error}) do
    Logger.error(inspect(error))
    raise "error updating addresses"
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
  def change_address(%Address{} = address, attrs) do
    Address.update_changeset(address, attrs)
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
    query =
      from(
        e in Address,
        where: e.address == ^address,
        select: e.address
      )

    case Repo.all(query)
         |> List.first() do
      nil ->
        false

      :string ->
        true
    end
  end

  # get all addresses involved in a transaction
  def get_transaction_addresses(vins, vouts, time, asset) do
    lookups =
      (Helpers.map_vins(vins) ++
         Helpers.map_vouts(vouts) ++
         [
           asset["admin"]
         ])
      |> Enum.filter(fn address -> address != nil end)
      |> Enum.uniq()

    query =
      from(
        e in Address,
        where: e.address in ^lookups,
        select: struct(e, [:id, :address, :balance, :tx_count])
      )

    Repo.all(query)
    |> fetch_missing(lookups, time)
    |> Helpers.gen_attrs()
  end

  # get all addresses involved in a transaction
  def get_transfer_addresses(addresses, time) do
    query =
      from(
        e in Address,
        where: e.address in ^addresses,
        select: struct(e, [:id, :address, :balance, :tx_count])
      )

    Repo.all(query)
    |> fetch_missing(addresses, time)
    |> Helpers.gen_attrs()
  end

  # get all addresses involved in a list of previous transactions
  def get_transactions_addresses(transactions) do
    lookups =
      Enum.reduce(transactions, [], fn %{:vin => vin, :vouts => vouts}, acc ->
        acc ++ Helpers.map_vins(vin) ++ Helpers.map_vouts(vouts)
      end)
      |> Enum.uniq()

    query =
      from(
        e in Address,
        where: e.address in ^lookups,
        order_by: [
          desc: e.updated_at
        ],
        select: map(e, [:id, :address, :balance, :time, :tx_count]),
        limit: 5
      )

    Repo.all(query)
  end

  # create missing addresses
  def fetch_missing(address_list, lookups, time) do
    (lookups -- Enum.map(address_list, fn %{:address => address} -> address end))
    |> Enum.map(fn address -> create_address(%{"address" => address, "time" => time}) end)
    |> Enum.concat(address_list)
  end

  # Update vins and claims into addresses
  def update_all_addresses(
        address_list,
        [],
        nil,
        _vouts,
        txid,
        index,
        time
      ) do
    address_list
    |> insert_tx_in_addresses(txid, index, time)
  end

  def update_all_addresses(
        address_list,
        [],
        claims,
        vouts,
        _txid,
        index,
        time
      ) do
    address_list
    |> Claims.separate_txids_and_insert_claims(claims, vouts, index, time)
  end

  def update_all_addresses(
        address_list,
        vins,
        nil,
        _vouts,
        txid,
        index,
        time
      ) do
    address_list
    |> group_vins_by_address_and_update(vins, txid, index, time)
  end

  def update_all_addresses(
        address_list,
        vins,
        claims,
        vouts,
        txid,
        index,
        time
      ) do
    address_list
    |> group_vins_by_address_and_update(vins, txid, index, time)
    |> Claims.separate_txids_and_insert_claims(claims, vouts, index, time)
  end

  def update_all_addresses(
        address_list,
        transfers,
        time,
        block
      ) do
    address_list
    |> add_transfers_to_addresses(transfers, time, block)
  end

  # separate vins by address hash, insert vins and update the address
  def group_vins_by_address_and_update(address_list, vins, txid, index, time) do
    updates =
      Enum.group_by(vins, fn %{:address_hash => address} -> address end)
      |> Map.to_list()
      |> Helpers.populate_groups(address_list)
      |> Enum.map(fn {address, vins} ->
        insert_vins_in_address(address, vins, txid, index, time)
      end)

    Enum.map(address_list, fn {address, attrs} ->
      Helpers.substitute_if_updated(address, attrs, updates)
    end)
  end

  # insert vins into address balance
  def insert_vins_in_address({address, attrs}, vins, txid, index, time) do
    new_attrs =
      Map.merge(attrs, %{
        :balance => Helpers.check_if_attrs_balance_exists(attrs) || address.balance,
        :tx_ids => Helpers.check_if_attrs_txids_exists(attrs) || %{}
      })
      |> add_vins(vins, time)
      |> BalanceHistories.add_tx_id(txid, index, time)

    {address, new_attrs}
  end

  # add multiple vins
  def add_vins(attrs, vins, time) do
    Enum.reduce(vins, attrs, fn vin, acc -> add_vin(acc, vin, time) end)
  end

  # add a single vin into adress
  def add_vin(%{:balance => balance} = attrs, vin, time) do
    current_amount = balance[vin.asset]["amount"]

    new_balance = %{
      "asset" => vin.asset,
      "amount" => current_amount - vin.value,
      "time" => time
    }

    %{attrs | balance: Map.put(attrs.balance || %{}, vin.asset, new_balance)}
  end

  def insert_tx_in_addresses(address_list, txid, index, time) do
    address_list
    |> Enum.map(fn tuple -> insert_tx_in_address(tuple, txid, index, time) end)
  end

  def insert_tx_in_address({address, attrs}, txid, index, time) do
    new_attrs =
      Map.merge(attrs, %{
        :balance => Helpers.check_if_attrs_balance_exists(attrs) || address.balance,
        :tx_ids => Helpers.check_if_attrs_txids_exists(attrs) || %{}
      })
      |> BalanceHistories.add_tx_id(txid, index, time)

    {address, new_attrs}
  end

  def add_transfers_to_addresses(addresses, [], _time, _block) do
    addresses
  end

  def add_transfers_to_addresses(addresses, [head | tail], time, block) do
    addresses
    |> add_transfer(head, time, block)
    |> add_transfers_to_addresses(tail, time, block)
  end

  def add_transfer(addresses, transfer, time, block) do
    update_from =
      Enum.filter(addresses, fn {address, _attrs} -> address.address == transfer["addr_from"] end)
      |> update_from_address(transfer, time)

    update_to =
      Enum.filter(addresses, fn {address, _attrs} -> address.address == transfer["addr_to"] end)
      |> update_to_address(transfer, time)

    transfer
    |> Transfers.create_transfer(time, block)

    Enum.map(addresses, fn {address, attrs} ->
      Helpers.substitute_if_updated(address, attrs, [update_from, update_to])
    end)
  end

  def update_from_address({address, attrs}, transfer, time) do
    new_attrs =
      Map.merge(attrs, %{
        :balance => Helpers.check_if_attrs_balance_exists(attrs) || address.balance,
        :tx_ids => Helpers.check_if_attrs_txids_exists(attrs) || %{}
      })
      |> minus_transfer(transfer, time)
      |> BalanceHistories.add_tx_id(transfer["tx"], transfer["block"], time)

    {address, new_attrs}
  end

  def update_to_address({address, attrs}, transfer, time) do
    new_attrs =
      Map.merge(attrs, %{
        :balance => Helpers.check_if_attrs_balance_exists(attrs) || address.balance,
        :tx_ids => Helpers.check_if_attrs_txids_exists(attrs) || %{}
      })
      |> plus_transfer(transfer, time)
      |> BalanceHistories.add_tx_id(transfer["tx"], transfer["block"], time)

    {address, new_attrs}
  end

  def plus_transfer(%{:balance => balance} = attrs, transfer, time) do
    current_amount = balance[transfer["contract"]]["amount"]

    new_balance = %{
      "asset" => transfer["contract"],
      "amount" => current_amount + transfer["amount"],
      "time" => time
    }

    %{attrs | balance: Map.put(attrs.balance || %{}, transfer["contract"], new_balance)}
  end

  def minus_transfer(%{:balance => balance} = attrs, transfer, time) do
    current_amount = balance[transfer["contract"]]["amount"]

    new_balance = %{
      "asset" => transfer["contract"],
      "amount" => current_amount - transfer["amount"],
      "time" => time
    }

    %{attrs | balance: Map.put(attrs.balance || %{}, transfer["contract"], new_balance)}
  end
end
