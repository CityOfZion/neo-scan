use Mix.Config

config :neoscan_monitor, ecto_repos: []

config :neoscan_monitor, should_start: Mix.env() not in [:test]
