defmodule NeoscanWeb.ApiController do
  use NeoscanWeb, :controller

  alias NeoscanWeb.Api

  defmacro cache(key, value, ttl \\ 10_000) do
    quote do
      ConCache.get_or_store(:my_cache, unquote(key), fn ->
        %ConCache.Item{value: unquote(value), ttl: unquote(ttl)}
      end)
    end
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_balance/:hash" do
    title("Get address balance")
    description("Returns the balance for an address from its `hash_string`")
    parameter(:hash, :string, description: "base 58 address hash")
  end

  def get_balance(conn, %{"hash" => hash}) do
    balance = cache({:get_balance, hash}, Api.get_balance(Base58.decode(hash)))
    json(conn, balance)
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_last_transactions_by_address/:hash" do
    title("Get address last transactions")
    description("Returns transactions")
    parameter(:hash, :string, description: "base 58 address hash")
  end

  def get_last_transactions_by_address(conn, %{"hash" => address_hash} = params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    address_hash = Base58.decode(address_hash)

    transactions =
      cache(
        {:get_last_transactions_by_address, address_hash, page},
        Api.get_last_transactions_by_address(address_hash, page)
      )

    json(conn, transactions)
  end

  # used by neon-js
  def get_all_nodes(conn, %{}) do
    nodes = cache({:get_all_nodes}, Api.get_all_nodes())
    json(conn, nodes)
  end

  # used by neon-js
  def get_unclaimed(conn, %{"hash" => address_hash}) do
    address_hash = Base58.decode(address_hash)
    unclaimed = cache({:get_unclaimed, address_hash}, Api.get_unclaimed(address_hash))
    json(conn, unclaimed)
  end

  # used by neon-js
  def get_claimable(conn, %{"hash" => address_hash}) do
    address_hash = Base58.decode(address_hash)
    claimable = cache({:get_claimable, address_hash}, Api.get_claimable(address_hash))
    json(conn, claimable)
  end

  # used by neon-js
  def get_height(conn, %{}) do
    height = cache({:get_height}, Api.get_height())
    json(conn, height)
  end

  # used by neon-js 3.7.0 (deprecated)
  def get_address_neon(conn, %{"hash" => address_hash}) do
    address_hash = Base58.decode(address_hash)
    address = cache({:get_address_neon, address_hash}, Api.get_address_neon(address_hash))
    json(conn, address)
  end

  # used by NEX
  def get_address_abstracts(conn, %{"hash" => address_hash} = params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    address_hash = Base58.decode(address_hash)

    abstracts =
      cache(
        {:get_address_abstracts, address_hash, page},
        Api.get_address_abstracts(address_hash, page)
      )

    json(conn, abstracts)
  end

  # used by NEX
  def get_address_to_address_abstracts(
        conn,
        %{"hash1" => address_hash1, "hash2" => address_hash2} = params
      ) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])
    address_hash1 = Base58.decode(address_hash1)
    address_hash2 = Base58.decode(address_hash2)

    abstracts =
      cache(
        {:get_address_to_address_abstracts, address_hash1, address_hash2, page},
        Api.get_address_to_address_abstracts(address_hash1, address_hash2, page)
      )

    json(conn, abstracts)
  end

  # for future use
  def get_claimed(conn, %{"hash" => hash}) do
    claimed = cache({:get_claimed, hash}, Api.get_claimed(Base58.decode(hash)))
    json(conn, claimed)
  end

  # for future use
  def get_block(conn, %{"hash" => hash}) do
    hash = parse_index_or_hash(hash)
    block = cache({:get_block, hash}, Api.get_block(hash))
    json(conn, block)
  end

  # for future use
  def get_transaction(conn, %{"hash" => hash}) do
    hash = parse_index_or_hash(hash)
    transaction = cache({:get_transaction, hash}, Api.get_transaction(hash))
    json(conn, transaction)
  end

  defp parse_index_or_hash(value) do
    case Integer.parse(value) do
      {integer, ""} ->
        integer

      _ ->
        Base.decode16!(value, case: :mixed)
    end
  end
end
