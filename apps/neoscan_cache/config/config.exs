use Mix.Config

config :neoscan_cache, ecto_repos: []

config :neoscan_cache, should_start: Mix.env() not in [:test]
