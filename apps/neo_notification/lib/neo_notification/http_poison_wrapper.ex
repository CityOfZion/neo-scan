defmodule NeoNotification.HTTPPoisonWrapper do
  @moduledoc false

  def get(url, headers, opts) do
    HTTPoison.get(url, headers, opts)
  end
end
