defmodule NeoscanWeb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :neoscan_web,
      version: "2.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_options: [
        warnings_as_errors: true
      ],
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {NeoscanWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.3"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.1", only: :dev},
      {:gettext, "~> 0.15"},
      {:blue_bird, "~> 0.3.8"},
      {:neoscan, in_umbrella: true},
      {:neoscan_cache, in_umbrella: true},
      {:neoscan_node, in_umbrella: true},
      {:neovm, in_umbrella: true},
      {:excoveralls, "~> 0.9", only: :test},
      {:cowboy, "~> 1.1"},
      {:cors_plug, "~> 1.5"},
      {:wobserver, "~> 0.1"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_phoenix, "~> 1.4"},
      {:timex, "~> 3.3"},
      {:number, "~> 0.5.4"},
      {:base58, github: "adrienmo/base58"}
    ]
  end

  def blue_bird_info do
    [
      host: "https://neoscan.io",
      title: "NEOSCAN API",
      description: """
      Main API for accessing data from the explorer. All data is provided through GET requests in `/api/main_net/v1`.
      """
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
