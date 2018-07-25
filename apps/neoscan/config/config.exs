use Mix.Config

config :neoscan, ecto_repos: [Neoscan.Repo]

config :neoscan, use_block_cache: true

config :neoscan, :deprecated_tokens, [
  Base.decode16!("2e25d2127e0240c6deaf35394702feb236d4d7fc", case: :mixed),
  Base.decode16!("fd48828f107f400c1ae595366f301842886ec573", case: :mixed)
]

import_config "#{Mix.env()}.exs"
