use Mix.Config

config :neoscan_sync, ecto_repos: []

config :logger, :console,
  format: "$date $time $metadata[$level] [$node] $message\n",
  metadata: [:request_id]

config :neoscan_sync, notification_seeds: [
  "http://notifications.neeeo.org",
  # "https://pyrpc2.redpulse.com",
  # "https://pyrpc2.redpulse.com",
]
