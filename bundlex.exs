defmodule MyApp.BundlexProject do
  use Bundlex.Project

  def project() do
    [
      nifs: nifs(Bundlex.platform())
    ]
  end

  defp nifs(_platform) do
    [
      console: [
        deps: [membrane_common_c: :membrane],
        sources: ["console.c"]
      ]
    ]
  end
end
