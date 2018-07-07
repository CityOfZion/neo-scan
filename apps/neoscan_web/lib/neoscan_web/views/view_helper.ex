defmodule NeoscanWeb.ViewHelper do
  @moduledoc "Contains function used in multiple views"
  use NeoscanWeb, :view
  alias Plug.Conn

  def get_tooltips(conn) do
    Conn.get_session(conn, "tooltips")
  end
end
