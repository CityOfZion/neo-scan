use Mix.Config

config :neo_price, crypto_compare_url: "min-api.cryptocompare.com"

if Mix.env() in [:travis, :test] do
  config :neo_price, cache_sync_interval: 1_000
else
  config :neo_price, cache_sync_interval: 10_000
end