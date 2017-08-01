use Mix.Config

config :neoscan, Neoscan.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "neoscan_prodv",
  hostname: "localhost",
  pool_size: 30

#import_config "prod.secret.exs"
