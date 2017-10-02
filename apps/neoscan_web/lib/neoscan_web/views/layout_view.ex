defmodule NeoscanWeb.LayoutView do
  use NeoscanWeb, :view
  alias Phoenix.Controller

  def is_home_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.HomeController
  end

  def is_blocks_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.BlocksController
  end

  def is_transactions_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.TransactionsController
  end

  def is_addresses_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.AddressesController
  end

  def is_about_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.AboutController
  end

  def is_assets_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.AssetsController
  end

end
