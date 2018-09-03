use Mix.Config

config :neoscan, Neoscan.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${DB_USERNAME}",
  password: "${DB_PASSWORD}",
  database: "${DB_DATABASE}",
  hostname: "${DB_HOSTNAME}",
  timeout: 60_000

# import_config "prod.secret.exs"
