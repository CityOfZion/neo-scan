use Mix.Config

config :neoscan, ecto_repos: [Neoscan.Repo]

config :neoscan, use_block_cache: true

config :neoscan, governing_token: Base.decode16!("c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b", case: :mixed)

config :neoscan, utility_token: Base.decode16!("602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7", case: :mixed)

config :neoscan, :deprecated_tokens, [
  Base.decode16!("2e25d2127e0240c6deaf35394702feb236d4d7fc", case: :mixed),
  Base.decode16!("fd48828f107f400c1ae595366f301842886ec573", case: :mixed)
]

import_config "#{Mix.env()}.exs"
