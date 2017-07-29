defmodule NeoscanWeb.DocController do
  use NeoscanWeb, :controller

  plug :action

  def index(conn, _params) do
    conn
    |> redirect(to: "/doc/Neoscan.Api.html")
    |> halt
  end

end
