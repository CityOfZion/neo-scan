use Mix.Config

config :neoprice, crypto_compare_url: "min-api.cryptocompare.com"

if Mix.env() in [:test] do
  config :neoprice, cache_sync_interval: 1_000
else
  config :neoprice, cache_sync_interval: 10_000
end
