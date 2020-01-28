use Mix.Config

config :neoscan_node,
  node_list_url:
    "https://raw.githubusercontent.com/CityOfZion/neo-mon/master/docs/assets/mainnet.json"

config :neoscan_node,
  seeds: [
    "https://seed1.switcheo.network:10331",
    "https://seed3.switcheo.network:10331",
    "http://seed1.travala.com:10332",
    "https://seed1.neo.org:10331",
    "https://seed1.cityofzion.io:443",
    "https://seed2.cityofzion.io:443",
    "https://seed3.cityofzion.io:443",
    "https://seed4.cityofzion.io:443",
    "https://seed5.cityofzion.io:443",
    "https://seed0.cityofzion.io:443",
    "https://seed6.cityofzion.io:443",
    "https://seed7.cityofzion.io:443",
    "https://seed8.cityofzion.io:443",
    "https://seed9.cityofzion.io:443",
    "https://seed1.redpulse.com:443",
    "https://seed2.redpulse.com:443",
    "https://seed.o3node.org:10331",
    "http://seed1.aphelion-neo.com:10332",
    "http://seed2.aphelion-neo.com:10332",
    "http://seed4.aphelion-neo.com:10332",
    "https://seed1.spotcoin.com:10332",
    "http://rustylogic.ddns.net:10332",
    "http://seed1.ngd.network:10332",
    "http://seed2.ngd.network:10332",
    "http://seed3.ngd.network:10332",
    "http://seed4.ngd.network:10332",
    "http://seed5.ngd.network:10332",
    "http://seed6.ngd.network:10332",
    "http://seed7.ngd.network:10332",
    "http://seed8.ngd.network:10332",
    "http://seed9.ngd.network:10332",
    "http://seed10.ngd.network:10332"
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
