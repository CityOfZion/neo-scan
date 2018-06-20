defmodule Neoscan.Transactions do
  @moduledoc false

  @moduledoc """
  The boundary for the Transactions system.
  """

  @page_size 15

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Claim
  alias Neoscan.Transaction
  alias Neoscan.AddressHistory

  @doc """
  Returns the list of transactions in the home page.

  ## Examples

      iex> home_transactions()
      [%Transaction{}, ...]

  """
  def home_transactions do
    transaction_query =
      from(
        e in Transaction,
        order_by: [
          desc: e.block_time
        ],
        where: e.type != "miner_transaction",
        limit: @page_size,
        preload: [:vouts]
      )

    Repo.all(transaction_query)
  end

  @doc """
  Gets a single transaction by its hash value
  ## Examples
      iex> get_block_by_hash(123)
      %Block{}
      iex> get_block_by_hash(456)
      nil
  """
  def get_transaction_by_hash(hash) do
    query = from(t in Transaction, where: t.hash == ^hash)
    Repo.one(query)
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
    query =
      from(
        e in Transaction,
        where: e.hash == ^hash,
        preload: [
          {:vins, ^vin_query()},
          {:vouts, ^vout_query()},
          :transfers,
          {:claims, ^claim_query()},
          :asset
        ],
        select: e
      )

    Repo.one(query)
  end

  @doc """
  Returns the list of paginated transactions.
  ## Examples
      iex> paginate_transactions(page)
      [%Transaction{}, ...]
  """
  def paginate_transactions(pag), do: paginate_transactions(pag, nil)

  def paginate_transactions(pag, _) do
    transaction_query =
      from(
        t in Transaction,
        order_by: [
          desc: t.block_index
        ],
        preload: [
          {:vins, ^vin_query()},
          {:vouts, ^vout_query()},
          :transfers,
          {:claims, ^claim_query()},
          :asset
        ]
      )

    Repo.paginate(transaction_query, page: pag, page_size: @page_size)
  end

  def get_for_block(block_hash, page) do
    transaction_query =
      from(
        t in Transaction,
        where: t.block_hash == ^block_hash,
        preload: [{:vins, ^vin_query()}, :vouts, :transfers, {:claims, ^claim_query()}],
        order_by: t.block_time,
        select: t,
        limit: @page_size
      )

    Repo.paginate(transaction_query, page: page, page_size: @page_size)
  end

  defp claim_query do
    from(
      claim in Claim,
      join: vout in Vout,
      on: claim.vout_n == vout.n and claim.vout_transaction_hash == vout.transaction_hash,
      select: vout
    )
  end

  defp vin_query do
    from(
      vin in Vin,
      join: vout in Vout,
      on: vin.vout_n == vout.n and vin.vout_transaction_hash == vout.transaction_hash,
      select: vout
    )
  end

  defp vout_query do
    from(
      v in Vout,
      order_by: [
        asc: v.n
      ]
    )
  end

  def get_for_address(address_hash, page) do
    transaction_query =
      from(
        t in Transaction,
        distinct: t.hash,
        join: ah in AddressHistory,
        on: ah.transaction_hash == t.hash,
        where: ah.address_hash == ^address_hash,
        preload: [{:vins, ^vin_query()}, :vouts, :transfers, {:claims, ^claim_query()}, :asset],
        order_by: ah.block_time,
        select: t,
        limit: @page_size
      )

    Repo.paginate(transaction_query, page: page, page_size: @page_size)
  end
end
