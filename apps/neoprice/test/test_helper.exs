defmodule Neoprice.Cryptocompare.HTTPPoisonWrapper do
  @moduledoc "poison wrapper"

  def get("successful"), do: {:ok, :ok}
  def get("error"), do: {:error, :error}

  def get("https://min-api.cryptocompare.com/data/histoday?" <> query) do
    args = Enum.into(URI.query_decoder(query), %{})
    to = div(String.to_integer(args["toTs"]), 86_400) * 86_400
    http_response(histoday_body(to))
  end

  def get("https://min-api.cryptocompare.com/data/histohour?fsym=MYCOIN200" <> _) do
    non_json_response()
  end

  def get("https://min-api.cryptocompare.com/data/histohour?fsym=MYCOIN500" <> _) do
    error_response()
  end

  def get("https://min-api.cryptocompare.com/data/histohour?" <> query) do
    args = Enum.into(URI.query_decoder(query), %{})
    to = div(String.to_integer(args["toTs"]), 3600) * 3600
    http_response(histohour_body(to))
  end

  def get("https://min-api.cryptocompare.com/data/histominute?" <> query) do
    args = Enum.into(URI.query_decoder(query), %{})
    to = div(String.to_integer(args["toTs"]), 60) * 60
    http_response(histominute_body(to))
  end

  def get("https://min-api.cryptocompare.com/data/pricemultifull?" <> query) do
    args = Enum.into(URI.query_decoder(query), %{})
    to_symbol = args["tsyms"]
    from_symbol = args["fsyms"]
    http_response(pricemultifull_body(from_symbol, to_symbol))
  end

  def get("https://min-api.cryptocompare.com/data/price?" <> query) do
    args = Enum.into(URI.query_decoder(query), %{})
    to_symbol = args["tsyms"]
    _from_symbol = args["fsyms"]
    http_response(price_body(to_symbol))
  end

  def get(_), do: {:error, :fake_not_found}

  defp price_body(to) do
    %{to => 0.006812}
  end

  def non_json_response do
    {
      :ok,
      %HTTPoison.Response{
        body: "nonjson",
        headers: [],
        request_url: "",
        status_code: 200
      }
    }
  end

  def error_response do
    {
      :ok,
      %HTTPoison.Response{
        body: "nonjson",
        headers: [],
        request_url: "",
        status_code: 500
      }
    }
  end

  def http_response(body) do
    {
      :ok,
      %HTTPoison.Response{
        body: Poison.encode!(body),
        headers: [],
        request_url: "",
        status_code: 200
      }
    }
  end

  defp data_points(to, incr) do
    from = to - incr * 30

    for t <- :lists.seq(from, to, incr) do
      %{
        "time" => t,
        "close" => 0.006891,
        "high" => 0.006934,
        "low" => 0.006867,
        "open" => 0.006906,
        "volumefrom" => 19933.41,
        "volumeto" => 137.46
      }
    end
  end

  defp pricemultifull_body(from_symbol, to_symbol) do
    %{
      "RAW" => %{
        from_symbol => %{
          to_symbol => %{
            "TYPE" => "5",
            "MARKET" => "CCCAGG",
            "FROMSYMBOL" => from_symbol,
            "TOSYMBOL" => to_symbol,
            "FLAGS" => "4",
            "PRICE" => 48.53,
            "LASTUPDATE" => 1_527_578_567,
            "LASTVOLUME" => 4.319,
            "LASTVOLUMETO" => 209.588113,
            "LASTTRADEID" => "251376094",
            "VOLUMEDAY" => 31602.50330692997,
            "VOLUMEDAYTO" => 1_526_543.7631600488,
            "VOLUME24HOUR" => 103_507.11681424998,
            "VOLUME24HOURTO" => 5_034_205.2688370515,
            "OPENDAY" => 47.81,
            "HIGHDAY" => 49.1,
            "LOWDAY" => 47.51,
            "OPEN24HOUR" => 49.49,
            "HIGH24HOUR" => 50.3,
            "LOW24HOUR" => 47.49,
            "LASTMARKET" => "Bitfinex",
            "CHANGE24HOUR" => -0.9600000000000009,
            "CHANGEPCT24HOUR" => -1.939785815316227,
            "CHANGEDAY" => 0.7199999999999989,
            "CHANGEPCTDAY" => 1.5059610960050174,
            "SUPPLY" => 65_000_000,
            "MKTCAP" => 3_154_450_000,
            "TOTALVOLUME24H" => 884_715.1251859241,
            "TOTALVOLUME24HTO" => 42_946_229.915114395
          }
        }
      },
      "DISPLAY" => %{
        from_symbol => %{
          to_symbol => %{
            "FROMSYMBOL" => from_symbol,
            "TOSYMBOL" => to_symbol,
            "MARKET" => "CryptoCompare Index",
            "PRICE" => "$ 48.53",
            "LASTUPDATE" => "Just now",
            "LASTVOLUME" => "NEO 4.32",
            "LASTVOLUMETO" => "$ 209.59",
            "LASTTRADEID" => "251376094",
            "VOLUMEDAY" => "NEO 31,602.5",
            "VOLUMEDAYTO" => "$ 1,526,543.8",
            "VOLUME24HOUR" => "NEO 103,507.1",
            "VOLUME24HOURTO" => "$ 5,034,205.3",
            "OPENDAY" => "$ 47.81",
            "HIGHDAY" => "$ 49.10",
            "LOWDAY" => "$ 47.51",
            "OPEN24HOUR" => "$ 49.49",
            "HIGH24HOUR" => "$ 50.30",
            "LOW24HOUR" => "$ 47.49",
            "LASTMARKET" => "Bitfinex",
            "CHANGE24HOUR" => "$ -0.96",
            "CHANGEPCT24HOUR" => "-1.94",
            "CHANGEDAY" => "$ 0.72",
            "CHANGEPCTDAY" => "1.51",
            "SUPPLY" => "NEO 65,000,000.0",
            "MKTCAP" => "$ 3,154.45 M",
            "TOTALVOLUME24H" => "NEO 884.72 K",
            "TOTALVOLUME24HTO" => "$ 42.95 M"
          }
        }
      }
    }
  end

  defp histoday_body(to) do
    %{
      "Response" => "Success",
      "Type" => 100,
      "Aggregated" => false,
      "Data" => data_points(to, 3_600 * 24)
    }
  end

  defp histohour_body(to) do
    %{
      "Response" => "Success",
      "Type" => 100,
      "Aggregated" => false,
      "Data" => data_points(to, 3_600)
    }
  end

  defp histominute_body(to) do
    %{
      "Response" => "Success",
      "Type" => 100,
      "Aggregated" => false,
      "Data" => data_points(to, 60)
    }
  end
end

ExUnit.start()
