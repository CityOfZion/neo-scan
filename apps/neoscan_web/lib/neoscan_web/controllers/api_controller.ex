defmodule NeoscanWeb.ApiController do
  use NeoscanWeb, :controller

  alias Neoscan.Api
  alias NeoscanCache.Api, as: CacheApi

  defmacro cache(key, value, ttl \\ 10_000) do
    quote do
      ConCache.get_or_store(:my_cache, unquote(key), fn ->
        %ConCache.Item{value: unquote(value), ttl: unquote(ttl)}
      end)
    end
  end

  def get_balance(conn, %{"hash" => hash}) do
    balance = cache({:get_balance, hash}, Api.get_balance(hash))
    json(conn, balance)
  end

  def get_claimed(conn, %{"hash" => hash}) do
    claimed = cache({:get_claimed, hash}, Api.get_claimed(hash))
    json(conn, claimed)
  end

  def get_unclaimed(conn, %{"hash" => hash}) do
    unclaimed = cache({:get_unclaimed, hash}, Api.get_unclaimed(hash))
    json(conn, unclaimed)
  end

  def get_claimable(conn, %{"hash" => hash}) do
    claimable = cache({:get_claimable, hash}, Api.get_claimable(hash))
    json(conn, claimable)
  end

  def get_address(conn, %{"hash" => hash}) do
    address = cache({:get_address, hash}, Api.get_address(hash))
    json(conn, address)
  end

  def get_address_neon(conn, %{"hash" => hash}) do
    address = cache({:get_address_neon, hash}, Api.get_address_neon(hash))
    json(conn, address)
  end

  def get_address_abstracts(conn, %{"hash" => hash, "page" => page}) do
    abstracts = cache({:get_address_abstracts, hash, page}, Api.get_address_abstracts(hash, page))
    json(conn, abstracts)
  end

  def get_address_to_address_abstracts(conn, %{"hash1" => hash1, "hash2" => hash2, "page" => page}) do
    abstracts =
      cache(
        {:get_address_to_address_abstracts, hash1, hash2, page},
        Api.get_address_to_address_abstracts(hash1, hash2, page)
      )

    json(conn, abstracts)
  end

  def get_assets(conn, _params) do
    assets =
      CacheApi.get_assets()
      |> Enum.map(fn x ->
        Map.delete(x, :inserted_at)
        |> Map.delete(:updated_at)
        |> Map.delete(:id)
      end)

    json(conn, assets)
  end

  def get_asset(conn, %{"hash" => hash}) do
    asset = cache({:get_asset, hash}, Api.get_asset(hash))
    json(conn, asset)
  end

  defp parse_index_or_hash(value) do
    case Integer.parse(value) do
      {integer, ""} ->
        integer

      _ ->
        Base.decode16!(value, case: :mixed)
    end
  end

  def get_block(conn, %{"hash" => hash}) do
    block = cache({:get_block, hash}, Api.get_block(parse_index_or_hash(hash)))
    json(conn, block)
  end

  def get_last_blocks(conn, _params) do
    blocks = cache({:get_last_blocks}, Api.get_last_blocks())
    json(conn, blocks)
  end

  def get_highest_block(conn, _params) do
    block = cache({:get_highest_block}, Api.get_highest_block())
    json(conn, block)
  end

  def get_transaction(conn, %{"hash" => hash}) do
    transaction = cache({:get_transaction, hash}, Api.get_transaction(hash))
    json(conn, transaction)
  end

  def get_last_transactions(conn, %{"type" => type}) do
    transactions = cache({:get_last_transactions, type}, Api.get_last_transactions(type))
    json(conn, transactions)
  end

  def get_last_transactions(conn, %{}) do
    transactions = cache({:get_last_transactions}, Api.get_last_transactions(nil))
    json(conn, transactions)
  end

  def get_last_transactions_by_address(conn, %{"hash" => hash, "page" => page}) do
    transactions =
      cache(
        {:get_last_transactions_by_address, hash, page},
        Api.get_last_transactions_by_address(hash, page)
      )

    json(conn, transactions)
  end

  def get_last_transactions_by_address(conn, %{"hash" => hash}) do
    get_last_transactions_by_address(conn, %{"hash" => hash, "page" => 1})
  end

  def get_all_nodes(conn, %{}) do
    nodes = cache({:get_all_nodes}, Api.get_all_nodes())
    json(conn, nodes)
  end

  def get_nodes(conn, %{}) do
    nodes = cache({:get_nodes}, Api.get_nodes())
    json(conn, nodes)
  end

  def get_height(conn, %{}) do
    height = cache({:get_height}, Api.get_height())
    json(conn, height)
  end

  def get_fees_in_range(conn, %{"range" => range}) do
    fees = cache({:get_fees_in_range, range}, Api.get_fees_in_range(range))
    json(conn, fees)
  end
end
