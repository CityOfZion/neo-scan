defmodule Neoprice do
  @moduledoc false

  use Application
  alias Neoprice.NeoBtc
  alias Neoprice.NeoUsd

  def start(_type, _args) do

    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      NeoBtc.worker,
      NeoUsd.worker
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neoprice.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
