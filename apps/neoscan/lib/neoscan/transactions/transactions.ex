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

  @type_list [
    "PublishTransaction",
    "ContractTransaction",
    "InvocationTransaction",
    "IssueTransaction",
    "RegisterTransaction",
    "EnrollmentTransaction",
    "ClaimTransaction"
  ]

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
  Count total transactions in DB.

  ## Examples

      iex> count_transactions()
      50

  """
  def count_transactions(type_list \\ @type_list) do
    query = from t in Transaction,
              where: t.type in ^type_list
    Repo.aggregate(query, :count, :type)
  end

  @doc """
  Count total transactions in DB.

  ## Examples

      iex> count_transactions()
      50

  """
  def count_transactions_for_type(type) do
    query = from t in Transaction,
                where: t.type == ^type
    Repo.aggregate(query, :count, :type)
  end

  @doc """
  Count total transactions in DB for an especific asset.

  ## Examples

      iex> count_transactions_for_asset(asset_hash)
      20

  """
  def count_transactions_for_asset(asset_hash) do
    query = from t in Transaction,
            where: t.asset_moved == ^asset_hash

    Repo.aggregate(query, :count, :asset_moved)
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
                               desc: e.id
                             ],
                             where: e.inserted_at > ago(
                               1,
                               "hour"
                             ) and e.type != "MinerTransaction",
                             select: %{
                               :id => e.id,
                               :type => e.type,
                               :time => e.time,
                               :txid => e.txid,
                               :block_height => e.block_height,
                               :block_hash => e.block_hash,
                               :vin => e.vin,
                               :claims => e.claims,
                               :sys_fee => e.sys_fee,
                               :net_fee => e.net_fee,
                               :size => e.size,
                               :asset => e.asset,
                             },
                             limit: 15

    Repo.all(transaction_query)
  end

  @doc """
  Returns the list of the last transactions for an asset.

  ## Examples

      iex> home_transactions()
      [%Transaction{}, ...]

  """
  def get_last_transactions_for_asset(hash) do
    transaction_query = from e in Transaction,
                             order_by: [
                               desc: e.id
                             ],
                             where: e.asset_moved == ^hash and e.type != "MinerTransaction",
                             select: %{
                               :id => e.id,
                               :type => e.type,
                               :time => e.time,
                               :txid => e.txid,
                               :block_height => e.block_height,
                               :block_hash => e.block_hash,
                               :vin => e.vin,
                               :claims => e.claims,
                               :sys_fee => e.sys_fee,
                               :net_fee => e.net_fee,
                               :size => e.size,
                               :asset => e.asset,
                             },
                             limit: 5

    transactions = Repo.all(transaction_query)

    vouts = Enum.map(transactions, fn tx -> tx.id end)
              |> get_transactions_vouts

    transactions
    |> Enum.map(fn tx ->
         Map.put(tx, :vouts, Enum.filter(vouts, fn vout ->
           vout.transaction_id == tx.id
         end))
       end)
  end

  @doc """
  Returns the list of paginated transactions.

  ## Examples

      iex> paginate_transactions(page)
      [%Transaction{}, ...]

  """
  def paginate_transactions(pag, type_list \\ @type_list) do
    type_list =
      case length(type_list) do
        1 ->
          formatted_type =
            type_list
            |> Enum.at(0)
            |> String.capitalize()
            |> Kernel.<>("Transaction")

          [formatted_type]
        _ -> type_list
      end
    transaction_query = from e in Transaction,
                        order_by: [
                          desc: e.id
                        ],
                        where: e.type in ^type_list,
                        select: %{
                         :id => e.id,
                         :type => e.type,
                         :time => e.time,
                         :txid => e.txid,
                         :block_height => e.block_height,
                         :block_hash => e.block_hash,
                         :vin => e.vin,
                         :claims => e.claims,
                         :sys_fee => e.sys_fee,
                         :net_fee => e.net_fee,
                         :size => e.size,
                         :asset => e.asset,
                        }

    transactions = Repo.paginate(transaction_query, page: pag, page_size: 15)
    vouts = Enum.map(transactions, fn tx -> tx.id end)
              |> get_transactions_vouts

    transactions
    |> Enum.map(fn tx ->
         Map.put(tx, :vouts, Enum.filter(vouts, fn vout ->
           vout.transaction_id == tx.id
         end))
       end)
  end

  @doc """
  Returns the list of paginated transactions.

  ## Examples

      iex> paginate_transactions(page)
      [%Transaction{}, ...]

  """
  def paginate_transactions_for_block(id, pag) do
    transaction_query = from e in Transaction,
                        order_by: [
                          desc: e.id
                        ],
                        where: e.block_id == ^id,
                        select: %{
                         :id => e.id,
                         :type => e.type,
                         :time => e.time,
                         :txid => e.txid,
                         :block_height => e.block_height,
                         :block_hash => e.block_hash,
                         :vin => e.vin,
                         :claims => e.claims,
                         :sys_fee => e.sys_fee,
                         :net_fee => e.net_fee,
                         :size => e.size,
                         :asset => e.asset,
                        }

    transactions = Repo.paginate(transaction_query, page: pag, page_size: 15)
    vouts = Enum.map(transactions, fn tx -> tx.id end)
              |> get_transactions_vouts

    transactions
    |> Enum.map(fn tx ->
         Map.put(tx, :vouts, Enum.filter(vouts, fn vout ->
           vout.transaction_id == tx.id
         end))
       end)
  end

  @doc """
  Returns the list of vouts for a transaction.

  ## Examples

      iex> get_transaction_vouts(id)
      [%Vout{}, ...]

  """
  def get_transaction_vouts(id) do
    vout_query = from e in Vout,
                             order_by: [
                               asc: e.n
                             ],
                             where: e.transaction_id == ^id,
                             select: %{
                               :asset => e.asset,
                               :address_hash => e.address_hash,
                               :value => e.value,
                             }

    Repo.all(vout_query)
  end

  @doc """
  Returns the list of vouts for many transaction.

  ## Examples

      iex> get_transaction_vouts(id)
      [%Vout{}, ...]

  """
  def get_transactions_vouts(id_list) do
    vout_query = from e in Vout,
                             order_by: [
                               asc: e.n
                             ],
                             where: e.transaction_id in ^id_list,
                             select: %{
                               :transaction_id => e.transaction_id,
                               :asset => e.asset,
                               :address_hash => e.address_hash,
                               :value => e.value,
                             }

    Repo.all(vout_query)
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
                               desc: e.id
                             ],
                             where: e.type == "PublishTransaction"
                                    or e.type == "InvocationTransaction",
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
                      order_by: [
                        asc: v.n
                      ],
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
      fn -> Addresses.get_transaction_addresses(new_vin, vouts, time, attrs["asset"])
            |> Addresses.update_all_addresses(
                 new_vin,
                 new_claim,
                 vouts,
                 String.slice(to_string(txid), -64..-1),
                 height,
                 time
               )
      end
    ) #updates addresses with vin and claims,
      # vouts are just for record in claims,
      # the balance is updated in the insert vout function called in create_vout

    #create asset if register Transaction
    ChainAssets.create(
      attrs["asset"],
      String.slice(to_string(txid), -64..-1),
      time
    )

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
                  |> set_transaction_asset(vouts)
                  |> Map.delete("vout")

    Transaction.changeset_with_block(block, transaction)
    |> Repo.insert!()
    |> update_transaction_state(vouts)
    |> Vouts.create_vouts(vouts, Task.await(address_list, 60_000))
  end

  #set transaction asset if it has vouts
  def set_transaction_asset(attrs, []) do
    attrs
  end
  def set_transaction_asset(attrs, vouts) do
    vout = List.first(vouts)
    Map.put(attrs, "asset_moved", String.slice(to_string(vout["asset"]), -64..-1))
  end

  #add transaction to monitor cache
  def update_transaction_state(%{:type => type} = transaction, vouts)
      when type != "MinerTransaction" do
    Api.add_transaction(transaction, vouts)
    transaction
  end
  def update_transaction_state(transaction, _vouts) do
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
                 select: struct(
                   e,
                   [:asset, :address_hash, :n, :value, :txid, :query, :id]
                 )

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
                 select: struct(
                   e,
                   [:asset, :address_hash, :n, :value, :txid, :query, :id]
                 )

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
    case Enum.each(
           transactions,
           fn transaction -> create_transaction(block, transaction) end
         ) do
      :ok ->
        {:ok, "Created"}
      _ ->
        {:error, "failed to create transactions"}
    end
  end

end
