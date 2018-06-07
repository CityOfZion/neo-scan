use Mix.Config

config :neoscan_sync, ecto_repos: []

config :logger, :console,
  format: "$date $time $metadata[$level] [$node] $message\n",
  metadata: [:request_id]

config :neoscan_sync,
  # Block height to start notifications check
  # genstage demand size
  demand_size: 150

config :neoscan_sync, should_start: Mix.env() not in [:test]
