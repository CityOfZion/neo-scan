defmodule NeoscanCache.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias NeoscanCache.Cache
  alias NeoscanCache.DbPoller
  alias NeoscanCache.PricePoller
  alias NeoscanCache.Broadcast

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Cache, []),
      worker(DbPoller, []),
      worker(PricePoller, []),
      worker(Broadcast, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NeoscanCache.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
