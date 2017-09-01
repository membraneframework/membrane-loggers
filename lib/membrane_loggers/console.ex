defmodule Membrane.Loggers.Console do
  @moduledoc """
  This module contains implementation of membrane logger that uses NIF calls to
  print messages to console.
  """


  use Membrane.Log.Logger.Base
  alias Membrane.Loggers.ConsoleNative



  def handle_log(level, msg, timestamp, tags, state) do
    with :ok <- ConsoleNative.log_prefix(level, timestamp, tags),
          :ok <- handle_elem(msg),
          :ok <- ConsoleNative.log_sufix
    do
       {:ok, state}
    else
       {:error, reason} ->
         {:error, reason, state}
    end
  end



  defp handle_elem([]), do: :ok

  defp handle_elem(elem) when is_list(elem) do
    [head | tail] = elem
    case handle_elem(head) do
      :ok ->
        handle_elem(tail)
      other ->
        other
    end
  end

  defp handle_elem(elem) when is_tuple(elem) do
    case elem do
      {:binary, binary} ->
        ConsoleNative.log_binary(binary)
      _ ->
        {:error, :not_implemented}
    end
  end

  defp handle_elem(elem) when is_number(elem) do
    ConsoleNative.log_number elem
  end

  defp handle_elem(elem) when is_binary(elem) do
    ConsoleNative.log_text elem
  end
end
