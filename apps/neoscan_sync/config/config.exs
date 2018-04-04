use Mix.Config

config :neoscan_sync, ecto_repos: []

config :logger, :console,
  format: "$date $time $metadata[$level] [$node] $message\n",
  metadata: [:request_id]

config :neoscan_sync, notification_seeds: [
  "http://notifications1.neeeo.org/v1",
  "http://notifications2.neeeo.org/v1",
  "http://notifications3.neeeo.org/v1",
  "http://notifications4.neeeo.org/v1",
]

config :neoscan_sync, start_notifications: 1444800 #Block height to start notifications check
