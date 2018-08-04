defmodule NeoNode.HTTPPoisonWrapper do
  @moduledoc false

  def post(url, data, headers, opts) do
    HTTPoison.post(url, data, headers, opts)
  end
end
