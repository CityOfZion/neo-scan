defmodule NeoscanMonitor.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @should_start Application.get_env(:neoscan_monitor, :should_start)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(NeoscanMonitor.Server, []),
      worker(NeoscanMonitor.Worker, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NeoscanMonitor.Supervisor]
    Supervisor.start_link(if(@should_start, do: children, else: []), opts)
  end
end
