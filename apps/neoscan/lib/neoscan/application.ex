defmodule Neoscan.Application do
  @moduledoc """
  The Neoscan Application Service.

  The neoscan system business domain lives in this application.

  Exposes API to clients such as the `NeoscanWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  alias Neoscan.Blocks.BlocksCache

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(BlocksCache, []),
      supervisor(Neoscan.Repo, [])
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: Neoscan.Supervisor
    )
  end
end
