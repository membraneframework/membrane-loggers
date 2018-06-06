defmodule Membrane.Loggers.Mixfile do
  use Mix.Project
  Application.put_env(:bundlex, :membrane_loggers, __ENV__)

  @github_url "https://github.com/membraneframework/membrane-loggers"

  def project do
    [
      app: :membrane_loggers,
      compilers: [:bundlex] ++ Mix.compilers(),
      version: "0.1.0",
      elixir: "~> 1.6",
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
    extras: ["README.md"]
  ]
end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:membrane_core, "~> 0.1"},
      {:bundlex, "~> 0.1"},
      {:membrane_common_c, "~> 0.1"}
    ]
  end
end
