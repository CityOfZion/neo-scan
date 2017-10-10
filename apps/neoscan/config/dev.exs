use Mix.Config

# Configure your database
config :neoscan, Neoscan.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USERNAME") || "postgress",
  password: System.get_env("DATABASE_PASSWORD") || "postgres",
  database: System.get_env("DATABASE_NAME") || "neoscan_dev",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  pool_size: System.get_env("DATABASE_POOL_SIZE") || 10
