defmodule Neoprice.Cryptocompare.Api do
  @moduledoc false
  require Logger

  @url "min-api.cryptocompare.com"

  @app_name Application.get_env(:neo_price, :app_name, "neoscan")

  def last_price(from_symbol, to_symbol) do
    params = "fsym=#{from_symbol}&tsyms=#{to_symbol}"
    url = "https://" <> @url <> "/data/price?#{params}"
    {:ok, %{status_code: 200, body: body}} = HTTPoison.get(url)
    case Poison.decode(body) do
      {:ok, map} -> map[to_symbol]
      _ -> nil
    end
  end

  def get_historical_price(:day, from_symbol, to_symbol, limit,
        aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&e=CCCAGG&extraParams=#{@app_name}"
    HTTPoison.get("https://" <> @url <> "/data/histoday?" <> params)
    |> extract_data()
  end

  def get_historical_price(:hour, from_symbol, to_symbol, limit,
        aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&e=CCCAGG&extraParams=#{@app_name}"
    |> IO.inspect()
    HTTPoison.get("https://" <> @url <> "/data/histohour?" <> params)
    |> extract_data()
  end

  def get_historical_price(:minute, from_symbol, to_symbol, limit,
                                aggregate, to) do
    params = "fsym=#{from_symbol}&tsym=#{to_symbol}&limit=#{limit}&toTs=#{to}"
    params = params <> "&aggregate=#{aggregate}&extraParams=#{@app_name}"
    HTTPoison.get("https://" <> @url <> "/data/histominute?" <> params)
    |> extract_data()
  end

  defp extract_data({:ok, %{status_code: 200, body: body}}) do
    case Poison.decode(body) do
      {:ok, %{"Data" => data}} ->
        IO.inspect(length(data))
        Enum.map(data, fn(%{"open" => value, "time" => time}) ->
          {time, value}
        end)
      _ -> Logger.warn fn ->
        "Couldn't decode json #{body}"
      end
      []
    end
  end

  defp extract_data(error) do
    Logger.warn("Http error #{inspect(error)}")
    []
  end
end
