defmodule Membrane.Loggers.Console.Native do
  use Bundlex.Loader, nif: :console

  defnif log_text(text)
  defnif log_number(text)
  defnif log_prefix(level, time, tags)
  defnif log_sufix()
  defnif log_binary(binary)
end
