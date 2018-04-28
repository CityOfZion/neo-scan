defmodule NeoscanWeb.LayoutView do
  use NeoscanWeb, :view
  alias Phoenix.Controller
  alias Plug.Conn
  alias NeoscanWeb.ViewHelper

  @languages %{
    "en" => "English",
    "nl" => "Nederlands",
    "fr" => "Français",
    "pt-br" => "Português",
    "it" => "Italiano",
    "de" => "Deutsch",
    "ru" => "Русский",
    "ro" => "Română"
  }

  def is_home_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.HomeController
  end

  def is_blocks_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.BlocksController
  end

  def is_transactions_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.TransactionsController
  end

  def is_transfers_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.TransfersController
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

  def is_doc_path(conn) do
    Controller.controller_module(conn) == NeoscanWeb.DocController
  end

  def get_page(conn) do
    Controller.controller_module(conn)
    |> to_string
    |> String.replace("Elixir.NeoscanWeb.", "")
    |> String.replace("Controller", "")
  end

  def get_language(conn) do
    Conn.get_session(conn, "locale")
  end

  def get_lang_text(conn) do
    case @languages[get_language(conn)] do
      nil -> "English"
      lang -> lang
    end
  end

  def get_tooltips(conn) do
    ViewHelper.get_tooltips(conn)
  end
end
