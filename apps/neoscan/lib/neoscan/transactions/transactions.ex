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
  alias Neoscan.AddressTransaction

  @doc """
  Gets a single transaction by its hash and send it as a map
  ## Examples
      iex> get(123)
      %{}
      iex> get(456)
      nil
  """
  def get(hash) do
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
  Specific query for API
  """

  def api_get(hash) do
    transaction = get(hash)

    vouts =
      Repo.all(
        from(
          v in Vout,
          order_by: [asc: v.n],
          where: v.transaction_hash == ^transaction.hash,
          preload: [:asset]
        )
      )

    vins =
      Repo.all(
        from(
          v in Vout,
          join: vin in Vin,
          on: vin.vout_n == v.n and vin.vout_transaction_hash == v.transaction_hash,
          where: vin.transaction_hash == ^transaction.hash,
          preload: [:asset]
        )
      )

    claims =
      Repo.all(
        from(
          v in Vout,
          join: claim in Claim,
          on: claim.vout_n == v.n and claim.vout_transaction_hash == v.transaction_hash,
          where: claim.transaction_hash == ^transaction.hash,
          preload: [:asset]
        )
      )

    transaction
    |> Map.put(:vins, vins)
    |> Map.put(:vouts, vouts)
    |> Map.put(:claims, claims)
  end

  @doc """
  Returns the list of paginated transactions.
  ## Examples
      iex> paginate(page)
      [%Transaction{}, ...]
  """
  def paginate(page) do
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

    # override total entries to avoid counting the whole set
    Repo.paginate(
      transaction_query,
      page: page,
      page_size: @page_size,
      options: [total_entries: 10_000]
    )
  end

  def get_for_block(block_hash, page) do
    transaction_query =
      from(
        t in Transaction,
        where: t.block_hash == ^block_hash,
        preload: [{:vins, ^vin_query()}, :vouts, :transfers, {:claims, ^claim_query()}, :asset],
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
        join: at in AddressTransaction,
        on: at.transaction_hash == t.hash,
        where: at.address_hash == ^address_hash,
        preload: [{:vins, ^vin_query()}, :vouts, :transfers, {:claims, ^claim_query()}, :asset],
        order_by: [desc: at.block_time],
        select: t
      )

    Repo.paginate(
      transaction_query,
      page: page,
      page_size: @page_size,
      options: [total_entries: 10_000]
    )
  end

  def get_claimed_vouts(address_hash) do
    Repo.all(
      from(
        vout in Vout,
        join: claim in Claim,
        on: claim.vout_n == vout.n and claim.vout_transaction_hash == vout.transaction_hash,
        where: vout.address_hash == ^address_hash,
        select: {vout, claim}
      )
    )
  end

  def get_unspent_vouts(address_hash) do
    Repo.all(
      from(
        vout in Vout,
        where: vout.address_hash == ^address_hash and vout.spent == false,
        preload: [:asset]
      )
    )
  end
end
