defmodule FreeGeoIP.Mixfile do
  use Mix.Project

  def project do
    [
      app: :freegeoip,
      version: "0.0.4",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package,
      name: "FreeGeoIP",
      source_url: "https://github.com/juljimm/freegeoip-elixir",
      deps: deps,
      docs: docs,
      description: "Simple Elixir wrapper for freegeoip.net HTTP API.",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test],
    ]
  end

  def application do
    [applications: [:httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.0" },
      {:poison, "~> 1.5 or ~> 2.0"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:excoveralls, "~> 0.4", only: :test},
      {:inch_ex, "~> 0.5.1", only: :docs},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end

  def package do
    [# These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Julio Jiménez"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/juljimm/freegeoip-elixir",
               "Docs" => "https://hexdocs.pm/freegeoip"}]
  end

  def docs do
    [
      extras: ["README.md"]
    ]
  end

end
