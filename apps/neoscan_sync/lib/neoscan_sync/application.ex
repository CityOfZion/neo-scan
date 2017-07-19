defmodule NEOScanSync.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(NEOScanSync.BlockSync,[], [restart: :transient, max_restarts: 30, max_seconds: 30]),
      #worker(NEOScanSync.AddressSync,[], [restart: :transient, max_restarts: 30, max_seconds: 30]),
      # Starts a worker by calling: NEOScanSync.Worker.start_link(arg1, arg2, arg3)
      # worker(NEOScanSync.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NEOScanSync.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
