defmodule NeoscanWeb.BlocksController do
  use NeoscanWeb, :controller

  alias NeoscanMonitor.Api

  def index(conn, _params) do
    blocks = Api.get_blocks
    render(conn, "blocks.html", blocks: blocks)
  end

end
