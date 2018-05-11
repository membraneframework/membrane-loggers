defmodule Membrane.Loggers.Console do
  @moduledoc """
  This module contains implementation of membrane logger that uses NIF calls to
  print messages to console.
  """

  use Membrane.Log.Logger.Base
  alias __MODULE__.Native

  def handle_log(level, msg, time, tags, state) do
    with :ok <- Native.log_prefix(level, "#{time}", tags),
         :ok <- handle_elem(msg),
         :ok <- Native.log_sufix() do
      {:ok, state}
    else
      {:error, reason} ->
        {:error, reason, state}
    end
  end

  defp handle_elem([]), do: :ok

  defp handle_elem([head | tail]) do
    case handle_elem(head) do
      :ok ->
        handle_elem(tail)

      other ->
        other
    end
  end

  defp handle_elem({:binary, binary}) do
    Native.log_binary(binary)
  end

  defp handle_elem(elem) when is_number(elem) do
    Native.log_number(elem)
  end

  defp handle_elem(elem) when is_binary(elem) do
    Native.log_text(elem)
  end

  defp handle_elem(elem) do
    {:error, {:console_log, not_implemented_for: elem}}
  end
end
