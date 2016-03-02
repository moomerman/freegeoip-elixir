defmodule FreeGeoIP.Mixfile do
  use Mix.Project

  def project do
    [
      app: :freegeoip,
      version: "0.0.2",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package,
      name: "FreeGeoIP",
      source_url: "https://github.com/juljimm/freegeoip-elixir",
      deps: deps,
      docs: docs,
      description: "Simple Elixir wrapper for freegeoip.net HTTP API."
    ]
  end

  def application do
    [applications: [:httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8.0" },
      {:poison, "~> 1.5"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
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
