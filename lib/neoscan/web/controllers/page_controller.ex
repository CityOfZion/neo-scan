defmodule Neoscan.Web.PageController do
  use Neoscan.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
