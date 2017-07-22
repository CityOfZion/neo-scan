defmodule Neoscan.Web.Router do
  use Neoscan.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Neoscan.Web do
    pipe_through :browser # Use the default browser stack

    get "/doc", DocController, :index
    get "/assets", AssetsController, :show_assets
    get "/address/:address", AddressController, :show_address
    get "/transaction/:txid", TransactionController, :show_transaction
    get "/block/:hash", BlockController, :show_block

    get "/", HomeController, :index
    post "/", HomeController, :search
  end

  scope "/api/main_net/v1", Neoscan.Web do
    pipe_through :api

    get "/get_balance/:hash", ApiController, :get_balance
    get "/get_address/:hash", ApiController, :get_address
    get "/get_assets", ApiController, :get_assets
    get "/get_asset/:hash", ApiController, :get_asset
    get "/get_block/:hash", ApiController, :get_block
    get "/get_last_blocks", ApiController, :get_last_blocks
    get "/get_highest_block", ApiController, :get_highest_block
    get "/get_last_transactions", ApiController, :get_last_transactions
    get "/get_last_transactions/:type", ApiController, :get_last_transactions
    get "/get_transaction/:hash", ApiController, :get_transaction
  end

  # Other scopes may use custom stacks.
  # scope "/api", Neoscan.Web do
  #   pipe_through :api
  # end
end
