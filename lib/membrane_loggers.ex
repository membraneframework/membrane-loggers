defmodule Membrane.Loggers do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [

    ]

    opts = [strategy: :one_for_one, name: Membrane.Loggers]

    supervise(children, opts)
  end
end
