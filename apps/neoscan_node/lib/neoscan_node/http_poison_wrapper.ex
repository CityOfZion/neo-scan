defmodule NeoscanNode.HttpCalls.HTTPPoisonWrapper do
  @moduledoc false

  def post(url, data, headers, opts) do
    HTTPoison.post(url, data, headers, opts)
  end

  def get(url, headers, opts) do
    HTTPoison.get(url, headers, opts)
  end
end
