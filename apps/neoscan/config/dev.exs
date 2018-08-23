use Mix.Config

# Configure your database
config :neoscan, Neoscan.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "neoscan_dev",
  hostname: "postgres",
  timeout: 60_000
