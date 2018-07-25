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

    get("/address/:hash", AddressController, :index)
    get("/address/:hash/:page", AddressController, :page)

    get("/addresses/:page", AddressesController, :page)

    get("/block/:hash", BlockController, :index)
    get("/block/:hash/:page", BlockController, :page)

    get("/blocks/:page", BlocksController, :page)

    get("/docs", DocsController, :index)

    get("/price/:from/:to/:graph", PriceController, :index)

    get("/transaction/:hash", TransactionController, :index)

    get("/transactions/:page", TransactionsController, :page)
  end

  scope "/api/main_net/v1", NeoscanWeb do
    pipe_through(:api)

    # used by neon-js / wallet
    get("/get_balance/:hash", ApiController, :get_balance)
    get("/get_unclaimed/:hash", ApiController, :get_unclaimed)
    get("/get_claimable/:hash", ApiController, :get_claimable)
    get("/get_all_nodes", ApiController, :get_all_nodes)

    get(
      "/get_last_transactions_by_address/:hash",
      ApiController,
      :get_last_transactions_by_address
    )

    get(
      "/get_last_transactions_by_address/:hash/:page",
      ApiController,
      :get_last_transactions_by_address
    )

    get("/get_height", ApiController, :get_height)

    # Used by NEX
    get("/get_address_abstracts/:hash/:page", ApiController, :get_address_abstracts)

    get(
      "/get_address_to_address_abstracts/:hash1/:hash2/:page",
      ApiController,
      :get_address_to_address_abstracts
    )

    # for future use
    get("/get_claimed/:hash", ApiController, :get_claimed)
    get("/get_block/:hash", ApiController, :get_block)
    get("/get_transaction/:hash", ApiController, :get_transaction)
  end

  # Other scopes may use custom stacks.
  # scope "/api", NeoscanWeb do
  #   pipe_through :api
  # end
end
