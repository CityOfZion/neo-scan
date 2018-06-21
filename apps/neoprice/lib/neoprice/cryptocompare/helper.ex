defmodule Neoprice.Cryptocompare.Helper do
  @moduledoc "helper methods"

  alias Neoprice.Cryptocompare.HTTPPoisonWrapper

  @retry_interval Application.get_env(:neoprice, :http_retry_interval)
  @total_retry 3

  def retry_get(url), do: retry_get(url, @total_retry)

  defp retry_get(_, 0), do: {:error, :retry_max}

  defp retry_get(url, n) do
    case HTTPPoisonWrapper.get(url) do
      {:ok, %HTTPoison.Response{status_code: code}} = result -> 
        case code do
          x when x in 200..299 -> result
          _ -> retry_get_handle_error(url, n)
        end
        
      _ ->
        retry_get_handle_error(url, n)
    end
  end

  defp retry_get_handle_error(url, n) do
    Process.sleep(@retry_interval * (@total_retry - n + 1))
    retry_get(url, n - 1)
  end
  
end
