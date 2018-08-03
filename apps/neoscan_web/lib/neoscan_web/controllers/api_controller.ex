defmodule NeoscanWeb.ApiController do
  use NeoscanWeb, :controller

  alias NeoscanWeb.Api

  @address_spec [
    address: %{
      type: :base58
    }
  ]
  @address_page_spec [
    address: %{
      type: :base58
    },
    page: %{
      type: :integer,
      default: 1
    }
  ]
  @address1_address_2_page_spec [
    address1: %{
      type: :base58
    },
    address2: %{
      type: :base58
    },
    page: %{
      type: :integer,
      default: 1
    }
  ]

  @block_hash_spec [
    block_hash: %{
      type: :integer_or_base16
    }
  ]

  @transaction_hash_spec [
    transaction_hash: %{
      type: :base16
    }
  ]

  apigroup("API v1", "")

  # used by neon-js
  api :GET, "/api/main_net/v1/get_balance/:address" do
    title("Get address balance")
    description("Returns the balance for an address including NEP5 Tokens.")
    parameter(:address, :string, description: "base 58 address")
  end

  def get_balance(conn, params) do
    if_valid_params(conn, params, @address_spec, do: Api.get_balance(parsed.address))
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_last_transactions_by_address/:address/:page" do
    title("Get address last transactions")

    description("""
      Returns the last 15 transaction models in the chain for the selected address
      from its hash, paginated.
    """)

    parameter(:address, :string, description: "base 58 address")
    parameter(:page, :integer, description: "page index", optional: true)
  end

  def get_last_transactions_by_address(conn, params) do
    if_valid_params conn, params, @address_page_spec do
      Api.get_last_transactions_by_address(parsed.address, parsed.page)
    end
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_all_nodes" do
    title("Get all neo nodes")

    description("""
      Returns all working nodes and their respective heights.
      Information is updated each minute.
    """)
  end

  def get_all_nodes(conn, _) do
    json(conn, Api.get_all_nodes())
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_unclaimed/:address" do
    title("Get address unclaimed gas")
    description("Returns the unclaimed gas for an address from its hash.")
    parameter(:address, :string, description: "base 58 address")
  end

  def get_unclaimed(conn, params) do
    if_valid_params(conn, params, @address_spec, do: Api.get_unclaimed(parsed.address))
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_claimable/:address" do
    title("Get address claimable transactions")
    description(" Returns the AVAILABLE claimable transactions for an address, from its hash.")
    parameter(:address, :string, description: "base 58 address")
  end

  def get_claimable(conn, params) do
    if_valid_params(conn, params, @address_spec, do: Api.get_claimable(parsed.address))
  end

  # used by neon-js
  api :GET, "/api/main_net/v1/get_height" do
    title("Get last block index")
    description("Returns latest block index of the neoscan db.")
  end

  def get_height(conn, _) do
    json(conn, Api.get_height())
  end

  # used by NEX
  api :GET, "/api/main_net/v1/get_address_abstracts/:address/:page" do
    title("Get address transactions summary")
    description("Returns transaction summary an address from its hash, paginated")
    parameter(:address, :string, description: "base 58 address")
    parameter(:page, :integer, description: "page")
  end

  def get_address_abstracts(conn, params) do
    if_valid_params(
      conn,
      params,
      @address_page_spec,
      do: Api.get_address_abstracts(parsed.address, parsed.page)
    )
  end

  # used by NEX
  api :GET, "/api/main_net/v1/get_address_to_address_abstracts/:address1/:address2/:page" do
    title("Get address pair transactions summary")
    description("Returns transaction summary between two address from their hash, paginated")
    parameter(:address1, :string, description: "base 58 address")
    parameter(:address2, :string, description: "base 58 address")
    parameter(:page, :integer, description: "page")
  end

  def get_address_to_address_abstracts(conn, params) do
    if_valid_params conn, params, @address1_address_2_page_spec do
      Api.get_address_to_address_abstracts(parsed.address1, parsed.address2, parsed.page)
    end
  end

  # for future use
  api :GET, "/api/main_net/v1/get_claimed/:address" do
    title("Get address claimed transactions")
    description("Returns the claimed transactions for an address, from its hash")
    parameter(:hash, :string, description: "base 58 address")
  end

  def get_claimed(conn, params) do
    if_valid_params(conn, params, @address_spec, do: Api.get_claimed(parsed.address))
  end

  # for future use
  api :GET, "/api/main_net/v1/get_block/:block_hash" do
    title("Get block")
    description("Returns the block model from its hash or index")
    parameter(:hash, :string, description: "base 16 block hash")
  end

  def get_block(conn, params) do
    if_valid_params(conn, params, @block_hash_spec, do: Api.get_block(parsed.block_hash))
  end

  # for future use
  api :GET, "/api/main_net/v1/get_transaction/:transaction_hash" do
    title("Get transaction")
    description("Returns the transaction model from its hash")
    parameter(:transaction_hash, :string, description: "base 16 transaction hash")
  end

  def get_transaction(conn, params) do
    if_valid_params(
      conn,
      params,
      @transaction_hash_spec,
      do: Api.get_transaction(parsed.transaction_hash)
    )
  end
end
