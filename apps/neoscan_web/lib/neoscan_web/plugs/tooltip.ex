defmodule NeoscanWeb.Plugs.Tooltip do
  @moduledoc false
  alias Plug.Conn
  @tooltips ["on", "off"]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    tooltip = extract_tooltip(conn)
    conn = Conn.put_session(conn, "tooltips", tooltip)
    conn
  end

  defp extract_tooltip(conn) do
    with nil <- params_tooltip(conn),
      nil <- session_tooltip(conn)
    do
      "off"
    else
      tooltip -> validate(tooltip)
    end
  end

  defp params_tooltip(conn) do
    conn.params["tooltips"]
  end

  defp session_tooltip(conn) do
    Conn.get_session(conn, "tooltips")
  end

  defp validate(tooltip) when tooltip in @tooltips, do: tooltip
  defp validate(_), do: "off"
end
