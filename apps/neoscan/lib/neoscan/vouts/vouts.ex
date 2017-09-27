defmodule Neoscan.Vouts do
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Addresses
  alias Neoscan.BalanceHistories
  alias Neoscan.Vouts.Vout
  alias Neoscan.Repair
  alias Neoscan.Helpers
  alias Ecto.Multi


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
    updates = vouts
    |> insert_address(address_list)
    |> Enum.group_by(fn %{"address" => {address , _attrs}} -> address.address end)
    |> Map.to_list()
    |> Enum.map(fn {_address, vouts} -> insert_vouts_in_address(transaction, vouts) end)

    Enum.map(address_list, fn {address, attrs} -> Helpers.substitute_if_updated(address, attrs, updates) end)
    |> Addresses.update_multiple_addresses()
  end


  #insert address struct into vout
  def insert_address(vouts, address_list) do
    Enum.map(vouts, fn %{"address" => ad } = x ->
      Map.put(x, "address", Enum.find(address_list, fn {%{ :address => address }, _attrs} -> address == ad end))
    end)
  end

  #set end height for vouts
  def end_vouts_and_return(vouts, height) do
    Enum.map(vouts, fn vout -> {vout, Vout.update_changeset(vout, %{:end_height => height})} end)
    |> Enum.reduce(Multi.new, fn (tuple, acc) -> push_vout_into_multi(tuple, acc) end)
    |> Repo.transaction
    |> check_and_return_vouts(vouts)
  end

  #set claimed for vouts
  def set_claimed_and_return(vouts) do
    Enum.map(vouts, fn vout -> {vout, Vout.update_changeset(vout, %{:claimed => true})} end)
    |> Enum.reduce(Multi.new, fn (tuple, acc) -> push_vout_into_multi(tuple, acc) end)
    |> Repo.transaction()
    |> check_and_return_vouts(vouts)
  end

  #push changes into multi operation
  def push_vout_into_multi({vout, changeset} , acc) do
    name = String.to_atom(vout.query)

    acc
    |> Multi.update(name, changeset, [])
  end

  def check_and_return_vouts({:ok, _any}, vouts) do
    Enum.map(vouts, fn %{:asset => asset, :address_hash => address_hash, :n => n, :value => value, :txid => txid} -> %{:asset => asset, :address_hash => address_hash, :n => n, :value => value, :txid => txid} end)
  end
  def check_and_return_vouts({:error, _any}, _vouts) do
    raise "error updating vouts"
  end


  #check if all vouts were found
  def verify_vouts(result, lookups, root) do
    cond do
      Enum.count(result) == Enum.count(lookups) ->
        result
      true ->
        Repair.repair_missing(result, root)
    end
  end

  #insert vouts into address balance
  def insert_vouts_in_address(%{:txid => txid, :block_height => index, :time => time} = transaction, vouts) do
    %{"address" => {address , attrs }} = List.first(vouts)
    new_attrs = Map.merge( attrs, %{:balance => Helpers.check_if_attrs_balance_exists(attrs) || address.balance , :tx_ids => Helpers.check_if_attrs_txids_exists(attrs) || %{}})
      |> add_vouts(vouts, transaction)
      |> BalanceHistories.add_tx_id(txid, index, time)
    {address, new_attrs}
  end

  #add multiple vouts to address
  def add_vouts(attrs, vouts, transaction) do
    Enum.reduce(vouts, attrs, fn (vout, acc) ->
      create_vout(transaction, vout)
      |> add_vout(acc)
    end)
  end

  #add a single vout to adress
  def add_vout(%{:value => value} = vout, %{:balance => balance} = address) do
    current_amount = balance[vout.asset]["amount"] || 0
    new_balance = %{"asset" => vout.asset, "amount" => current_amount + value}
    %{address | balance: Map.put(address.balance || %{}, vout.asset, new_balance)}
  end

end
