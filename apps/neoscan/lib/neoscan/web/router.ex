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

    get "/transaction", TransactionController, :no_transaction
    get "/transaction/:id", TransactionController, :show_transaction

    get "/block", BlockController, :no_block
    get "/block/:id", BlockController, :show_block
    
    get "/", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Neoscan.Web do
  #   pipe_through :api
  # end
end
