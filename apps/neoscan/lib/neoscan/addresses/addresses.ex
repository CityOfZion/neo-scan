defmodule Neoscan.Addresses do
  @moduledoc """
  The boundary for the Addresses system.
  """

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  @gas_asset_hash <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16, 132,
                    227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45, 231>>

  @page_size 15

  import Ecto.Query, warn: false

  require Logger

  alias Neoscan.Repo
  alias Neoscan.Address
  alias Neoscan.AddressBalance
  alias Neoscan.AddressHistory
  alias Neoscan.Asset

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
          desc: a.last_transaction_time
        ],
        limit: 15
      )

    Repo.all(query)
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
    query = from(e in Address, where: e.hash == ^hash)

    # %{:address => e.address, :tx_ids => e.histories,
    #  :balance => e.balance, :claimed => e.claimed}
    Repo.one(query)
  end

  @doc """
  Gets a single address by its hash and send it as a map
  ## Examples
      iex> get_address_by_hash(123)
      %{}
      iex> get_address_by_hash(456)
      nil
  """
  def get_address_by_hash(hash), do: get_address_by_hash_for_view(hash)

  def get(hash), do: get_address_by_hash(hash)

  def get_balances(hash) do
    Repo.all(
      from(
        ab in AddressBalance,
        join: a in Asset,
        on: ab.asset_hash == a.transaction_hash,
        where: ab.address_hash == ^hash,
        select: %{name: a.name, asset: ab.asset_hash, value: ab.value, precision: a.precision}
      )
    )
  end

  def get_split_balance(nil), do: nil

  def get_split_balance(binary_hash) do
    balances = get_balances(binary_hash)
    neo_balance = Enum.find(balances, &(&1.asset == @neo_asset_hash))
    gas_balance = Enum.find(balances, &(&1.asset == @gas_asset_hash))

    token_balances =
      Enum.filter(balances, &(not (&1.asset in [@neo_asset_hash, @gas_asset_hash])))

    token_balances =
      Enum.map(token_balances, fn balance ->
        %{
          balance
          | name:
              Enum.reduce(balance.name, %{}, fn %{"lang" => lang, "name" => name}, acc ->
                Map.put(acc, lang, name)
              end)
        }
      end)

    %{
      neo: if(is_nil(neo_balance), do: 0, else: neo_balance.value),
      gas: if(is_nil(gas_balance), do: 0.0, else: gas_balance.value),
      tokens: token_balances
    }
  end

  def get_transactions_count do
    123
  end

  @doc """
  Returns the list of paginated addresses.
  ## Examples
      iex> paginate_addresses(page)
      [%Address{}, ...]
  """
  def paginate_addresses(page) do
    addresses_query =
      from(
        e in Address,
        order_by: [
          desc: e.last_transaction_time
        ],
        limit: @page_size
      )

    Repo.paginate(addresses_query, page: page, page_size: 15)
  end

  def get_balance_history(hash) do
    balances = get_balances(hash)

    balances =
      Enum.reduce(balances, %{}, fn %{value: value, name: name}, acc ->
        Map.put(acc, filter_name(name), value)
      end)

    address_history =
      Repo.all(
        from(
          ah in AddressHistory,
          where: ah.address_hash == ^hash,
          order_by: [desc: ah.block_time],
          preload: [:asset],
          limit: 200
        )
      )

    address_history =
      address_history
      |> Enum.group_by(& &1.block_time)
      |> Enum.map(fn {time, balances} ->
        %{time: DateTime.to_unix(time), assets: reduce_balance_to_assets(balances)}
      end)
      |> Enum.reverse()

    address_history
    |> Enum.reduce({[], balances}, fn %{assets: assets, time: time}, {acc, current} ->
      new_balances =
        Enum.reduce(assets, current, fn {name, value}, acc ->
          Map.update!(acc, name, &(&1 - value))
        end)

      elem = %{
        assets: Enum.map(assets, fn {name, _} -> %{name => Map.get(current, name)} end),
        time: time
      }

      {[elem | acc], new_balances}
    end)
    |> elem(0)
  end

  defp reduce_balance_to_assets(balances) do
    balances
    |> Enum.filter(&(not is_nil(&1.asset)))
    |> Enum.map(&{filter_name(&1.asset.name), &1.value})
    |> Enum.group_by(fn {asset_name, _} -> asset_name end, fn {_, value} -> value end)
    |> Enum.map(fn {asset_name, value_list} -> {asset_name, Enum.sum(value_list)} end)
    |> Enum.into(%{})
  end

  defp filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => "AntShare"} ->
        "NEO"

      %{"name" => "AntCoin"} ->
        "GAS"

      %{"name" => name} ->
        name

      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end
end
