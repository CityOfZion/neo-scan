defmodule NeoscanWeb.Application do
  @moduledoc false
  use Application
  alias NeoscanWeb.Endpoint

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      {
        ConCache,
        [
          name: :my_cache,
          ttl_check_interval: :timer.seconds(1),
          global_ttl: :timer.seconds(5)
        ]
      },
      supervisor(Endpoint, [])
      # Start your own worker by calling:
      # NeoscanWeb.Worker.start_link(arg1, arg2, arg3)
      # worker(NeoscanWeb.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NeoscanWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
