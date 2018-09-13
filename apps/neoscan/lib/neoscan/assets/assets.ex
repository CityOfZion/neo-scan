defmodule Neoscan.Assets do
  @moduledoc """
  The boundary for the Assets system.
  """

  @page_size 15

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Asset
  alias Neoscan.Counter

  @doc """
  Gets a single asset by its hash value
  ## Examples
      iex> get(123)
      %Block{}
      iex> get(456)
      nill
  """
  def get(hash) do
    query =
      from(
        a in Asset,
        left_join: ca in Counter,
        on: a.transaction_hash == ca.ref and ca.name == "addresses_by_asset",
        left_join: ct in Counter,
        on: a.transaction_hash == ct.ref and ct.name == "transactions_by_asset",
        where: a.transaction_hash == ^hash,
        select: %{
          transaction_hash: a.transaction_hash,
          name: a.name,
          block_time: a.block_time,
          type: a.type,
          owner: a.owner,
          admin: a.admin,
          issued: a.issued,
          precision: a.precision,
          amount: a.amount,
          addr_count: ca.value,
          tx_count: ct.value
        }
      )

    Repo.one(query)
  end

  @doc """
  Returns the list of paginated assets.
  ## Examples
      iex> paginate(page)
      [%Asset{}, ...]
  """
  def paginate(page) do
    assets_query =
      from(
        a in Asset,
        left_join: ca in Counter,
        on: a.transaction_hash == ca.ref and ca.name == "addresses_by_asset",
        left_join: ct in Counter,
        on: a.transaction_hash == ct.ref and ct.name == "transactions_by_asset",
        order_by: [desc: fragment("coalesce(?, 0)", ct.value)],
        limit: @page_size,
        select: %{
          transaction_hash: a.transaction_hash,
          name: a.name,
          block_time: a.block_time,
          type: a.type,
          owner: a.owner,
          admin: a.admin,
          issued: a.issued,
          precision: a.precision,
          amount: a.amount,
          symbol: a.symbol,
          addr_count: ca.value,
          tx_count: ct.value
        }
      )

    Repo.paginate(assets_query, page: page, page_size: @page_size)
  end
end
