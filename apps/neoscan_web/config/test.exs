use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :neoscan_web, NeoscanWeb.Endpoint,
  http: [port: 4001],
  secret_key_base: "J8EWtXVVWp+AmNn4fmdodz17pug1X8v8QbjiPnNf0IkeFYhY140Dhei7UGUACHXs",
  server: false
