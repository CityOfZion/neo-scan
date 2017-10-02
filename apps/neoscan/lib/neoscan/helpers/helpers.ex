defmodule Neoscan.Helpers do


  @doc """
  Populates tuples {address_hash, vins} with {%Adddress{}, vins}

  ## Examples

      iex> populate_groups(groups})
      [{%Address{}, _},...]


  """
  def populate_groups(groups, address_list) do
    Enum.map(
      groups,
      fn {address, vins} -> {Enum.find(address_list, fn {%{:address => ad}, _attrs} -> ad == address end), vins} end
    )
  end

  #helper to filter nil cases
  def map_vins(nil) do
    []
  end
  def map_vins(vins) do
    Enum.map(vins, fn %{:address_hash => address} -> address end)
  end

  #helper to filter nil cases
  def map_vouts(nil) do
    []
  end
  def map_vouts(vouts) do
    #not in db, so still uses string keys
    Enum.map(vouts, fn %{"address" => address} -> address end)
  end

  #generate {address, address_updates} tuples for following operations
  def gen_attrs(address_list) do
    address_list
    |> Enum.map(fn address -> {address, %{}} end)
  end

  #helpers to check if there are attrs updates already
  def check_if_attrs_balance_exists(%{:balance => balance}) do
    balance
  end
  def check_if_attrs_balance_exists(_attrs) do
    false
  end
  def check_if_attrs_txids_exists(%{:tx_ids => tx_ids}) do
    tx_ids
  end
  def check_if_attrs_txids_exists(_attrs) do
    false
  end
  def check_if_attrs_claimed_exists(%{:claimed => claimed}) do
    claimed
  end
  def check_if_attrs_claimed_exists(_attrs) do
    false
  end

  #helper to substitute main address list with updated addresses tuples
  def substitute_if_updated(%{:address => address_hash} = address, attrs, updates) do
    index = Enum.find_index(updates, fn {%{:address => ad}, _attrs} -> ad == address_hash end)
    case index do
      nil ->
        {address, attrs}
      _ ->
        Enum.at(updates, index)
    end
  end

end
