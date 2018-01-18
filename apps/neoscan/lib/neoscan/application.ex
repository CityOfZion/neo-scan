defmodule Neoscan.Application do
  @moduledoc """
  The Neoscan Application Service.

  The neoscan system business domain lives in this application.

  Exposes API to clients such as the `NeoscanWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link(
      [
        supervisor(Neoscan.Repo, [])
      ],
      strategy: :one_for_one,
      name: Neoscan.Supervisor
    )
  end
end
