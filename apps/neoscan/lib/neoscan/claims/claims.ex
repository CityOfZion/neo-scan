defmodule Neoscan.Claims do
  import Ecto.Query, warn: false
  alias Neoscan.Claims.Claim
  alias Neoscan.Helpers
  alias Ecto.Multi

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address claim changes.

  ## Examples

      iex> change_claim(claim)
      %Ecto.Changeset{source: %History{}}

  """
  def change_claim(%Claim{} = claim, address, attrs) do
    Claim.changeset(claim, address, attrs)
  end

  #separate claimed transactions and insert in the claiming addresses
  def separate_txids_and_insert_claims(address_list, claims, vouts, index, time) do
    updates = Stream.map(claims, fn %{:txid => txid} -> String.slice(to_string(txid), -64..-1) end)
    |> Stream.uniq()
    |> Enum.to_list
    |> insert_claim_in_addresses(vouts, address_list, index, time)

    Enum.map(address_list, fn {address, attrs} -> Helpers.substitute_if_updated(address, attrs, updates) end)
  end

  #get addresses and route for adding claims
  def insert_claim_in_addresses(transactions, vouts, address_list, index, time) do
    Enum.map(vouts, fn %{"address" => hash, "value" => value, "asset" => asset} ->
      insert_claim_in_address(Enum.find(address_list, fn {%{:address => address}, _attrs} -> address == hash end) , transactions, value, String.slice(to_string(asset), -64..-1), index, time)
    end)
  end

  #insert claimed transactions and update address balance
  def insert_claim_in_address({address, attrs}, transactions, value, asset, index, time) do
    new_attrs = Map.merge(attrs, %{:claimed => Helpers.check_if_attrs_claimed_exists(attrs) || %{}})
    |> add_claim(transactions, value, asset, index, time)

    {address, new_attrs}
  end

  #add a single claim into address
  def add_claim(address, transactions, amount, asset, index, time) do
    new_claim = %{:txids => transactions, :amount => amount, :asset => asset, :block_height => index, :time => time}
    %{address | claimed: new_claim}
  end

  #Insert new claim in multi if there was claim operations
  def add_claim_if_claim(multi, _name, nil) do
    multi
  end
  def add_claim_if_claim(multi, name, changeset) do
    multi
    |> Multi.insert(name, changeset, [])
  end


end
