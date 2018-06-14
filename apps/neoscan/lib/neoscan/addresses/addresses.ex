defmodule Neoscan.Addresses do
  @moduledoc """
  The boundary for the Addresses system.
  """

  import Ecto.Query, warn: false

  require Logger

  alias Neoscan.Repo
  alias Neoscan.Address
  alias Neoscan.AddressHistory
  alias Neoscan.AddressBalance

  alias Neoscan.Asset
  alias Neoscan.Transaction

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
        on: ab.asset == a.transaction_hash,
        where: ab.address_hash == ^hash,
        select: %{name: a.name, asset: ab.asset, value: ab.value, precision: a.precision}
      )
    )
  end

  def get_transactions(hash) do
    Repo.all(
      from(
        t in Transaction,
        join: ah in AddressHistory,
        on: ah.transaction_hash == t.hash,
        where: ah.address_hash == ^hash,
        preload: [:vins, :vouts, :transfers, :claims],
        order_by: ah.block_time,
        select: t
      )
    )
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
        limit: 15
      )

    Repo.paginate(addresses_query, page: page, page_size: 15)
  end
end
