defmodule NeoscanWeb.Plugs.Locale do
  @moduledoc false
  alias Plug.Conn
  @languages ["en", "nl", "fr", "pt-br", "it", "de", "ru", "ro", "jp", "zh"]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    locale = extract_locale(conn)
    conn = Conn.put_session(conn, "locale", locale)
    Gettext.put_locale(NeoscanWeb.Gettext, locale)
    conn
  end

  defp extract_locale(conn) do
    with nil <- params_locale(conn),
         nil <- session_locale(conn),
         nil <- req_header_locale(conn) do
      "en"
    else
      lang -> validate(lang)
    end
  end

  defp params_locale(conn) do
    conn.params["locale"]
  end

  defp session_locale(conn) do
    Conn.get_session(conn, "locale")
  end

  defp req_header_locale(conn) do
    case Conn.get_req_header(conn, "accept-language") do
      [language | _] ->
        splited =
          Regex.scan(~r/[a-z]/, language)
          |> List.flatten()

        Enum.find(splited, fn x -> x in @languages end)

      _ ->
        "en"
    end
  end

  defp validate(language) when language in @languages, do: language
  defp validate(_), do: "en"
end
