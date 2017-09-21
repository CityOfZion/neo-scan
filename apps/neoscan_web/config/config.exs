# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :neoscan_web,
  namespace: NeoscanWeb,
  ecto_repos: [Neoscan.Repo]

# Configures the endpoint
config :neoscan_web, NeoscanWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: NeoscanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NeoscanWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :neoscan_web, :generators,
  context_app: :neoscan

config :wobserver,
  mode: :plug,
  remote_url_prefix: "/wobserver"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
