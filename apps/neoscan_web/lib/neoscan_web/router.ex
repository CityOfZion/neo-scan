defmodule NeoscanWeb.Router do
  use NeoscanWeb, :router
  alias NeoscanWeb.Plugs.Locale
  alias NeoscanWeb.Plugs.Tooltip

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(Locale)
    plug(Tooltip)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  forward("/wobserver", Wobserver.Web.Router)

  scope "/", NeoscanWeb do
    pipe_through(:browser)

    get("/", HomeController, :index)
    post("/", HomeController, :search)

    get("/address/:address", AddressController, :index)
    get("/address/:address/:page", AddressController, :page)

    get("/addresses/:page", AddressesController, :page)

    get("/block/:block_hash", BlockController, :index)
    get("/block/:block_hash/:page", BlockController, :page)

    get("/blocks/:page", BlocksController, :page)

    get("/docs", DocsController, :index)

    get("/price/:from/:to/:graph", PriceController, :index)

    get("/transaction/:transaction_hash", TransactionController, :index)

    get("/transactions/:page", TransactionsController, :page)

    get("/asset/:asset_hash", AssetController, :index)

    get("/assets/:page", AssetsController, :page)
  end

  scope "/api/main_net/v1", NeoscanWeb do
    pipe_through(:api)

    # used by neon-js / wallet
    get("/get_balance/:address", ApiController, :get_balance)
    get("/get_unclaimed/:address", ApiController, :get_unclaimed)
    get("/get_claimable/:address", ApiController, :get_claimable)
    get("/get_all_nodes", ApiController, :get_all_nodes)

    get(
      "/get_last_transactions_by_address/:address",
      ApiController,
      :get_last_transactions_by_address
    )

    get(
      "/get_last_transactions_by_address/:address/:page",
      ApiController,
      :get_last_transactions_by_address
    )

    get("/get_height", ApiController, :get_height)

    # Used by NEX
    get("/get_address_abstracts/:address/:page", ApiController, :get_address_abstracts)

    get(
      "/get_address_to_address_abstracts/:address1/:address2/:page",
      ApiController,
      :get_address_to_address_abstracts
    )

    # for future use
    get("/get_claimed/:address", ApiController, :get_claimed)
    get("/get_block/:block_hash", ApiController, :get_block)
    get("/get_transaction/:transaction_hash", ApiController, :get_transaction)
  end

  scope "/graphql" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: NeoscanWeb.Schema,
      interface: :simple
    )

    forward("/", Absinthe.Plug, schema: NeoscanWeb.Schema)
  end

  # Other scopes may use custom stacks.
  # scope "/api", NeoscanWeb do
  #   pipe_through :api
  # end
end
