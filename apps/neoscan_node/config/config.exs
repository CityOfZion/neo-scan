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
      "http://notifications3.neeeo.org/v1",
      "http://notifications4.neeeo.org/v1",
      "https://n2.cityofzion.io/v1"
    ]
end

config :neoscan_node,
  seeds: [
    "https://seed0.cityofzion.io",
    "http://seed1.cityofzion.io:8080",
    "http://seed2.cityofzion.io:8080",
    "http://seed3.cityofzion.io:8080",
    "http://seed4.cityofzion.io:8080",
    "http://seed5.cityofzion.io:8080",
    "https://seed6.cityofzion.io",
    "https://seed7.cityofzion.io",
    "https://seed8.cityofzion.io",
    "http://seed1.ngd.network:10332",
    "http://seed2.ngd.network:10332",
    "http://seed3.ngd.network:10332",
    "http://seed4.ngd.network:10332",
    "http://seed5.ngd.network:10332",
    "http://seed6.ngd.network:10332",
    "http://seed7.ngd.network:10332",
    "http://seed8.ngd.network:10332",
    "http://seed9.ngd.network:10332",
    "http://seed10.ngd.network:10332",
    "https://seed1.neo.org:10331",
    "http://seed2.neo.org:10332",
    "http://seed3.neo.org:10332",
    "http://seed4.neo.org:10332",
    "http://seed5.neo.org:10332",
    "http://api.otcgo.cn:10332",
    "http://seed0.bridgeprotocol.io:10332",
    "http://seed1.bridgeprotocol.io:10332",
    "http://seed2.bridgeprotocol.io:10332",
    "http://seed3.bridgeprotocol.io:10332",
    "http://seed4.bridgeprotocol.io:10332",
    "http://seed5.bridgeprotocol.io:10332",
    "http://seed6.bridgeprotocol.io:10332",
    "http://seed7.bridgeprotocol.io:10332",
    "http://seed8.bridgeprotocol.io:10332",
    "http://seed9.bridgeprotocol.io:10332",
    "https://seed1.redpulse.com",
    "https://seed2.redpulse.com",
    "http://seed1.o3node.org:10332",
    "http://seed2.o3node.org:10332",
    "http://54.66.154.140:10332",
    "http://seed3.aphelion-neo.com:10332",
    "http://seed4.aphelion-neo.com:10332",
    "http://seed1.aphelion-neo.com:10332",
    "http://node1.ams2.bridgeprotocol.io:10332",
    "http://node1.sgp1.bridgeprotocol.io:10332",
    "http://node1.nyc3.bridgeprotocol.io:10332",
    "http://seed2.travala.com:10332",
    "http://seed3.travala.com:10332",
    "https://seed1.spotcoin.com:10332",
    "http://seed3.o3node.org:10332",
    "https://seed5.switcheo.network:10331",
    "https://seed3.switcheo.network:10331",
    "https://seed4.switcheo.network:10331",
    "https://seed2.switcheo.network:10331",
    "http://seed1.travala.com:10332"
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
