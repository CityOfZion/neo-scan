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
    # Use the default browser stack
    pipe_through(:browser)

    get("/", HomeController, :index)
    post("/", HomeController, :search)
    get("/address/:address", AddressController, :index)
    get("/address/:address/:page", AddressController, :go_to_page)
    get("/addresses/1", AddressesController, :index)
    get("/addresses/:page", AddressesController, :go_to_page)
    get("/block/:hash", BlockController, :index)
    get("/block/:hash/:page", BlockController, :go_to_page)
    get("/blocks/1", BlocksController, :index)
    get("/blocks/:page", BlocksController, :go_to_page)
    get("/doc", DocController, :index)
    get("/price/:from/:to/:graph", PriceController, :index)
    get("/transaction/:txid", TransactionController, :index)
    get("/transactions/1", TransactionsController, :index)
    get("/transactions/:page", TransactionsController, :go_to_page)
    get("/transactions/type/:type/:page", TransactionsController, :filtered_transactions)
    get("/transfers/1", TransfersController, :index)
    get("/transfers/:page", TransfersController, :go_to_page)
  end

  scope "/api/main_net/v1", NeoscanWeb do
    pipe_through(:api)

    get("/get_balance/:hash", ApiController, :get_balance)
    get("/get_claimed/:hash", ApiController, :get_claimed)
    get("/get_unclaimed/:hash", ApiController, :get_unclaimed)
    get("/get_claimable/:hash", ApiController, :get_claimable)
    get("/get_address/:hash", ApiController, :get_address)
    get("/get_address_neon/:hash", ApiController, :get_address_neon)
    get("/get_assets", ApiController, :get_assets)
    get("/get_asset/:hash", ApiController, :get_asset)
    get("/get_block/:hash", ApiController, :get_block)
    get("/get_last_blocks", ApiController, :get_last_blocks)
    get("/get_highest_block", ApiController, :get_highest_block)
    get("/get_last_transactions", ApiController, :get_last_transactions)
    get("/get_last_transactions/:type", ApiController, :get_last_transactions)

    get(
      "/get_last_transactions_by_address/:hash/:page",
      ApiController,
      :get_last_transactions_by_address
    )

    get(
      "/get_last_transactions_by_address/:hash",
      ApiController,
      :get_last_transactions_by_address
    )

    get("/get_transaction/:hash", ApiController, :get_transaction)
    get("/get_all_nodes", ApiController, :get_all_nodes)
    get("/get_height", ApiController, :get_height)
    get("/get_nodes", ApiController, :get_nodes)
    get("/get_fees_in_range/:range", ApiController, :get_fees_in_range)
    get("/repair_blocks", ApiController, :repair_blocks)
    get("/repair_block_counter", ApiController, :repair_block_counter)
    get("/get_address_abstracts/:hash/:page", ApiController, :get_address_abstracts)

    get(
      "/get_address_to_address_abstracts/:hash1/:hash2/:page",
      ApiController,
      :get_address_to_address_abstracts
    )
  end

  # Other scopes may use custom stacks.
  # scope "/api", NeoscanWeb do
  #   pipe_through :api
  # end
end
