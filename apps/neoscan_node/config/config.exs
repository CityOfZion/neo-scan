use Mix.Config

if Mix.env() == :test do
  config :neoscan_node,
    notification_seeds: [
      "http://notifications1.neeeo.org/v1"
    ]
else
  config :neoscan_node,
    notification_seeds: [
      "http://notifications1.neeeo.org/v1",
      "http://notifications2.neeeo.org/v1",
      "http://notifications3.neeeo.org/v1"
    ]
end

config :neoscan_node, start_notifications: 1_444_800

config :neoscan_node,
  seeds: [
    "http://seed1.cityofzion.io:8080",
    "http://seed2.cityofzion.io:8080",
    "http://seed3.cityofzion.io:8080",
    "http://seed4.cityofzion.io:8080",
    "http://seed5.cityofzion.io:8080",
    "https://seed1.neo.org:10331",
    "http://seed2.neo.org:10332",
    "http://seed3.neo.org:10332",
    "http://seed4.neo.org:10332",
    "http://seed5.neo.org:10332"
  ]

if Mix.env() == :test do
  config :neoscan_node,
    seeds: [
      "http://seed1.cityofzion.io:8080",
      "http://seed2.cityofzion.io:8080",
      "http://seed3.cityofzion.io:8080",
      "http://seed4.cityofzion.io:8080",
      "http://seed5.cityofzion.io:8080"
    ]
end
