use Mix.Config

config :neoprice, crypto_compare_url: "min-api.cryptocompare.com"

if Mix.env() in [:test] do
  config :neoprice, cache_sync_interval: 1_000
  config :neoprice, http_retry_interval: 1
else
  config :neoprice, cache_sync_interval: 10_000
  config :neoprice, http_retry_interval: 1_000
end
