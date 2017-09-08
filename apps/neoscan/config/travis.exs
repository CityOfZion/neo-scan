use Mix.Config

# Configure your database
config :neoscan, Neoscan.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "neoscan_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
