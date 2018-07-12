use Mix.Releases.Config,
    default_release: :neoscan,
    default_environment: Mix.env

environment :dev do
  set dev_mode: true
  set include_erts: true
  set include_system_libs: false
  set cookie: :"UHLs;22CbwNqpN?3g9`c|?.>XO;s%]yP0aup<SmL]`.8bAbujy1[%4.23%1Yf"
end

environment :prod do
  set include_erts: false
  set include_system_libs: false
  set cookie: :"UHLs;22CbwNqpN?3g9`c|?.>XO;s%]yP0aup<SmL]`.8bAbujy1[%4.23%1Ya"
end

release :neoscan do
  set version: current_version(:neoscan)
  set commands: ["migrate": "rel/commands/migrate.sh"]
  set applications: [
        :runtime_tools,
        :neoprice,
        :neoscan,
        neoscan_cache: :permanent,
        neoscan_node: :permanent,
        neoscan_sync: :permanent,
        neoscan_web: :permanent
      ]
end