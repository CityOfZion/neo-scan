defmodule Neoprice.Cryptocompare.Api do
  @moduledoc false
  require Logger

  alias Neoprice.Cryptocompare.Helper

  @url Application.get_env(:neoprice, :crypto_compare_url)
  @app_name Application.get_env(:neoprice, :app_name, "neoscan")

  def last_price(from_symbol, to_symbol) do
    params = "fsym=#{from_symbol}&tsyms=#{to_symbol}"
    url = "https://" <> @url <> "/data/price?#{params}"
    body = case Helper.retry_get(url) do
      {:ok, %{status_code: 200, body: body}} -> body
      _ -> {:error}
    end
    
    case Poison.decode(body) do
      {:ok, map} -> map[to_symbol]
      _ -> nil
    end
  end

  def last_price_full(from_symbol, to_symbol) do
    params = "fsyms=#{from_symbol}&tsyms=#{to_symbol}"
    url = "https://" <> @url <> "/data/pricemultifull?#{params}"
    case Helper.retry_get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, map} ->
            map["RAW"][from_symbol][to_symbol]

          _ -> nil
        end
      
      _ -> nil
    end
  end

  def get_historical_price(:day, from_symbol, to_symbol, limit, aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&e=CCCAGG&extraParams=#{@app_name}"

    Helper.retry_get("https://" <> @url <> "/data/histoday?" <> params)
    |> extract_data()
  end

  def get_historical_price(:hour, from_symbol, to_symbol, limit, aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&e=CCCAGG&extraParams=#{@app_name}"

    Helper.retry_get("https://" <> @url <> "/data/histohour?" <> params)
    |> extract_data()
  end

  def get_historical_price(:minute, from_symbol, to_symbol, limit, aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&extraParams=#{@app_name}"

    Helper.retry_get("https://" <> @url <> "/data/histominute?" <> params)
    |> extract_data()
  end

  defp extract_data({:ok, %{status_code: 200, body: body}}) do
    case Poison.decode(body) do
      {:ok, %{"Data" => data}} ->
        Enum.map(data, fn %{"open" => value, "time" => time} ->
          {time, value}
        end)

      _ ->
        Logger.warn(fn ->
          "Couldn't decode json #{body}"
        end)

        []
    end
  end

  defp extract_data(error) do
    Logger.warn("Http error #{inspect(error)}")
    []
  end
end
