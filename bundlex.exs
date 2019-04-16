defmodule Membrane.Loggers.BundlexProject do
  use Bundlex.Project

  def project() do
    [
      nifs: nifs()
    ]
  end

  defp nifs() do
    [
      console: [
        deps: [membrane_common_c: :membrane, bunch_native: :bunch_nif],
        sources: ["console.c"]
      ]
    ]
  end
end
