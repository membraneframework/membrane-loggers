defmodule Membrane.Loggers.Mixfile do
  use Mix.Project
  Application.put_env(:bundlex, :membrane_loggers, __ENV__)

  def project do
    [
      app: :membrane_loggers,
      compilers: [:bundlex] ++ Mix.compilers(),
      version: "0.0.1",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Membrane Multimedia Framework (Loggers)",
      maintainers: ["Mateusz Nowak"],
      licenses: ["Proprietary"],
      name: "Membrane Loggers",
      source_url: "https://github.com/membraneframework/membrane-loggers",
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [], mod: {Membrane.Loggers, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:membrane_core, git: "git@github.com:membraneframework/membrane-core.git"},
      {:bundlex, git: "git@github.com:radiokit/bundlex.git"},
      {:membrane_common_c, git: "git@github.com:membraneframework/membrane-common-c.git"}
    ]
  end
end
