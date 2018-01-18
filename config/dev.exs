use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "$date $time $metadata[$level] [$node] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20
