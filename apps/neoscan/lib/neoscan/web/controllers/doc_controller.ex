defmodule Neoscan.Web.DocController do
  use Neoscan.Web, :controller

  plug :action

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> redirect(to: "/doc/Neoscan.Api.html")
  end

end
