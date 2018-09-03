defmodule Plug.UrlRewrite do
  @moduledoc """

  """

  @behaviour Plug

  def init([]), do: []

  def call(
        %Plug.Conn{
          request_path: "/api/test_net/" <> rest_request_path,
          path_info: ["api", "test_net" | rest_path_info]
        } = conn,
        []
      ) do
    %{
      conn
      | request_path: "/api/main_net/" <> rest_request_path,
        path_info: ["api", "main_net" | rest_path_info]
    }
  end

  def call(%Plug.Conn{} = conn, []), do: conn
end
