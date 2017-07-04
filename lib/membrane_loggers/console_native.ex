defmodule Membrane.Loggers.ConsoleNative do
  @moduledoc """
  """
  require Bundlex.Loader

  @on_load :load_nifs

  @doc false
  def load_nifs do
    Bundlex.Loader.load_lib_nif!(:membrane_loggers, :membrane_loggers_console)
  end

  def log_text(_text), do: raise "NIF fail"
  def log_number(_text), do: raise "NIF fail"
  def log_prefix(_level, _timestamp), do: raise "NIF fail"
  def log_sufix(), do: raise "NIF fail"
  def log_binary(_binary), do: raise "NIF fail"
end
