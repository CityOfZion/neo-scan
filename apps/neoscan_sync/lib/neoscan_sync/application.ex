defmodule NeoscanSync.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias NeoscanSync.Syncer
  alias NeoscanSync.TokenSyncer

  @should_start Application.get_env(:neoscan_sync, :should_start)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [worker(Syncer, []), worker(TokenSyncer, [])]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: NeoscanSync.Supervisor]
    Supervisor.start_link(if(@should_start, do: children, else: []), opts)
  end
end
