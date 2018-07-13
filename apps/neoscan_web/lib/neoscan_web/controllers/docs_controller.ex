defmodule NeoscanWeb.DocsController do
  use NeoscanWeb, :controller

  plug(:action)

  def index(conn, _params) do
    conn
    |> redirect(to: "/docs/index.html")
    |> halt
  end
end
