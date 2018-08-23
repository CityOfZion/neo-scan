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
    "http://node2.nyc3.bridgeprotocol.io:10332",
    "http://seed4.aphelion-neo.com:10332",
    "http://node2.sgp1.bridgeprotocol.io:10332",
    "http://node2.ams2.bridgeprotocol.io:10332",
    "https://pyrpc1.narrative.org:443",
    "https://pyrpc4.narrative.org:443",
    "https://pyrpc2.narrative.org:443",
    "https://pyrpc3.narrative.org:443",
    "http://seed3.aphelion-neo.com:10332",
    "http://seed2.aphelion-neo.com:10332",
    "http://seed5.ngd.network:10332",
    "https://seed4.switcheo.network:10331",
    "https://seed2.switcheo.network:10331",
    "https://seed3.cityofzion.io:443",
    "https://seed5.cityofzion.io:443",
    "http://seed10.ngd.network:10332",
    "https://seed2.redpulse.com:443",
    "https://seed.o3node.org:10331",
    "https://seed3.switcheo.network:10331",
    "http://seed1.travala.com:10332",
    "https://seed2.cityofzion.io:443",
    "https://seed1.cityofzion.io:443",
    "http://seed1.ngd.network:10332",
    "https://seed5.switcheo.network:10331",
    "https://seed1.redpulse.com:443",
    "http://seed2.travala.com:10332",
    "https://seed1.switcheo.network:10331",
    "http://seed7.ngd.network:10332",
    "http://node1.ams2.bridgeprotocol.io:10332",
    "https://seed8.cityofzion.io:443",
    "http://rustylogic.ddns.net:10332",
    "http://api.otcgo.cn:10332",
    "https://seed6.cityofzion.io:443",
    "https://seed7.cityofzion.io:443",
    "https://seed0.cityofzion.io:443",
    "https://seed9.cityofzion.io:443",
    "http://pyrpc2.redpulse.com:10332",
    "http://pyrpc1.redpulse.com:10332",
    "https://pyrpc1.redpulse.com:10331",
    "https://pyrpc2.redpulse.com:10331"
  ]

if Mix.env() == :test do
  config :neoscan_node,
    seeds: [
      "https://seed1.cityofzion.io",
      "https://seed2.cityofzion.io",
      "https://seed3.cityofzion.io",
      "https://seed4.cityofzion.io",
      "https://seed5.cityofzion.io"
    ]
end
