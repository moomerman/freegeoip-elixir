defmodule FreeGeoIP.Mixfile do
  use Mix.Project

  def project do
    [app: :freegeoip,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
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
               "Docs" => "http://juljimm.github.io/freegeoip-elixir/"}]
  end
end
