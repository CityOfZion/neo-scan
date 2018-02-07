use Mix.Config

config :neoscan_monitor, ecto_repos: []

config :neoscan_monitor, seeds: [
      "http://seed1.cityofzion.io:8080",
      "http://seed2.cityofzion.io:8080",
      "http://seed3.cityofzion.io:8080",
      "http://seed4.cityofzion.io:8080",
      "http://seed5.cityofzion.io:8080",
      "http://api.otcgo.cn:10332",
      "http://seed1.neo.org:10332",
      "http://seed2.neo.org:10332",
      "http://seed3.neo.org:10332",
      "http://seed4.neo.org:10332",
      "http://seed5.neo.org:10332"
    ]