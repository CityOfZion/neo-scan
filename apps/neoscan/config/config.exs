use Mix.Config

config :neoscan, ecto_repos: [Neoscan.Repo]

config :neoscan, use_block_cache: false

import_config "#{Mix.env()}.exs"
