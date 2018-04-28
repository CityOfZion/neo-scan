defmodule Neoprice.Mixfile do
  use Mix.Project

  def project do
    [
      app: :neoprice,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Neoprice, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.11 or ~> 0.12 or ~> 0.13"},
      {:poison, "~> 2.0 or ~> 3.1"},
      {:mock, "~> 0.3.0", only: [:test, :travis]},
      {:excoveralls, "~> 0.8", only: [:test, :travis]}
    ]
  end
end
