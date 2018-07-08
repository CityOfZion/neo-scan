Bureaucrat.start()
ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Ecto.Adapters.SQL.Sandbox.mode(Neoscan.Repo, :manual)
