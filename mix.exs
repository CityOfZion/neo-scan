defmodule Neoscan.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),

      name: "NeoScan",
      docs: [
        main: "NeoScan", # The main page in the docs
        extras: ["README.md"]
      ],
      aliases: aliases()
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13"},
      {:flow, "~> 0.11"},
      {:ex_machina, "~> 2.0", only: [:test, :travis]},
      {:credo, "~> 0.8", only: [:dev, :travis]},
      {:morphix, "~> 0.0.7"},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
