defmodule Neoscan.Vouts do
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Addresses
  alias Neoscan.Vouts.Vout
  alias Neoscan.Repair
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
    |> Enum.map(fn {_address, vouts} -> Addresses.insert_vouts_in_address(transaction, vouts) end)

    Enum.map(address_list, fn {address, attrs} -> Addresses.substitute_if_updated(address, attrs, updates) end)
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

end
