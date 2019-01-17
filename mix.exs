defmodule Membrane.Loggers.Mixfile do
  use Mix.Project

  @version "0.2.2"
  @github_url "https://github.com/membraneframework/membrane-loggers"

  def project do
    [
      app: :membrane_loggers,
      compilers: [:bundlex] ++ Mix.compilers(),
      version: @version,
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Membrane Multimedia Framework (Loggers)",
      package: package(),
      name: "Membrane Loggers",
      source_url: @github_url,
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [], mod: {Membrane.Loggers, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      },
      files: [
        "lib",
        "c_src",
        "mix.exs",
        "README*",
        "LICENSE*",
        ".formatter.exs",
        "bundlex.exs"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev},
      {:membrane_core, "~> 0.2.0"},
      {:bundlex, "~> 0.1.5"},
      {:membrane_common_c, "~> 0.2.0"},
      {:bunch, "~> 0.2"},
      {:bunch_native, "~> 0.1"}
    ]
  end
end
