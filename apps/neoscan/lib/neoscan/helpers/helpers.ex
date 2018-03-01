defmodule Neoscan.Helpers do
  @moduledoc false

  @doc """
  Populates tuples {address_hash, vins} with {%Adddress{}, vins}

  ## Examples

      iex> populate_groups(groups})
      [{%Address{}, _},...]

  """
  def populate_groups(groups, address_list) do
    Enum.map(groups, fn {address, vins} ->
      {
        Enum.find(address_list, fn {%{:address => ad}, _attrs} -> ad == address end),
        vins
      }
    end)
  end

  # helper to filter nil cases
  def map_vins(nil) do
    []
  end

  def map_vins([]) do
    []
  end

  def map_vins([%{"address_hash" => _address} | _tail] = vins) do
    Enum.map(vins, fn %{"address_hash" => address} -> address end)
  end

  def map_vins([%{:address_hash => _address} | _tail] = vins) do
    Enum.map(vins, fn %{:address_hash => address} -> address end)
  end

  # helper to filter nil cases
  def map_vouts(nil) do
    []
  end

  def map_vouts([]) do
    []
  end

  def map_vouts([%{"address" => _address} | _tail] = vouts) do
    # not in db, so still uses string keys
    Enum.map(vouts, fn %{"address" => address} -> address end)
  end

  def map_vouts([%{:address_hash => _address} | _tail] = vouts) do
    # not in db, so still uses string keys
    Enum.map(vouts, fn %{:address_hash => address} -> address end)
  end

  # generate {address, address_updates} tuples for following operations
  def gen_attrs(address_list) do
    address_list
    |> Enum.map(fn address -> {address, %{}} end)
  end

  # helpers to check if there are attrs updates already
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

  # helper to substitute main address list with updated addresses tuples
  def substitute_if_updated(
        %{:address => address_hash} = address,
        attrs,
        updates
      ) do
    index = Enum.find_index(updates, fn {%{:address => ad}, _attrs} -> ad == address_hash end)

    case index do
      nil ->
        {address, attrs}

      _ ->
        Enum.at(updates, index)
    end
  end

  def round_or_not(value) do
    case Kernel.is_float(value) do
      true ->
        value

      false ->
        case Kernel.is_integer(value) do
          true ->
            value

          false ->
            {num, _} = Float.parse(value)
            num
        end
    end
    |> round_or_not!
  end

  defp round_or_not!(value) do
    if Kernel.round(value) == value do
      Kernel.round(value)
    else
      Float.round(value, 8)
    end
  end

  def contract?(hash) do
    cond do
      String.length(hash) == 64 ->
        false

      true ->
        true
    end
  end

  def apply_precision(integer, hash, precision) do
    cond do
      String.length(hash) == 40 ->
        num = integer / :math.pow(10, precision)
        
        "#{num}"
      true ->
        "#{integer}"
    end
  end
end
