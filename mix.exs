defmodule ExDocker.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_docker,
      version: "0.1.0",
      elixir: "~> 1.4",
      description: description(),
      package: package(),
      deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  def description do
    "Docker client for Elixir"
  end

  def package do
    [
      contributors: ["Andrea Maria Piana"],
      licenses: ["The MIT License"],
      links: %{
        "GitHub" => "https://github.com/cammellos/ex_docker"
      }
    ]
  end

  defp deps do
    [
      {:ibrowse, "~> 4.2"},
      {:httpoison, "~> 0.11.0"},
      {:mock, "~> 0.1", only: :test},
      {:poison, "~> 2.2.0"}
    ]
  end
end
