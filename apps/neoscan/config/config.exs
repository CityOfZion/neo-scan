use Mix.Config

config :neoscan, ecto_repos: [Neoscan.Repo]

import_config "#{Mix.env()}.exs"
