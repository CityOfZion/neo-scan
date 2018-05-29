defmodule Neoprice.Cryptocompare.Helper do
  @moduledoc "helper methods"

  alias Neoprice.Cryptocompare.Request

  @retry_interval Application.get_env(:neoprice, :http_retry_interval)
  @total_retry 3

  def retry_get(url), do: retry_get(url, @total_retry)

  defp retry_get(_, 0), do: {:error, :retry_max}

  defp retry_get(url, n) do
    case Request.get(url) do
      {:ok, _} = result ->
        result

      _ ->
        Process.sleep(@retry_interval * (@total_retry - n + 1))
        retry_get(url, n - 1)
    end
  end
end
