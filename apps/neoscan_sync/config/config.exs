use Mix.Config

config :neoscan_sync, ecto_repos: []

config :logger, :console,
  format: "$date $time $metadata[$level] [$node] $message\n",
  metadata: [:request_id]

config :neoscan_sync, notification_seeds: [
  "http://notifications.neeeo.org/v1",
  "https://pyrest1.redpulse.com/v1",
  "https://pyrest2.redpulse.com/v1",
  "https://pyrest1.narrative.network/v1",
  "https://pyrest2.narrative.network/v1",
  "https://pyrest3.narrative.network/v1",
  "https://pyrest4.narrative.network/v1",
]

config :neoscan_sync, start_notifications: 1444800 #Block height to start notifications check
