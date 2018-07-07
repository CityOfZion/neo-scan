defmodule Neoscan.Helpers do
  @moduledoc false

  def round_or_not(value) do
    case Kernel.is_float(value) do
      true ->
        value

      false ->
        case Kernel.is_integer(value) do
          true ->
            value

          false ->
            {num, _} = Float.parse(value)
            num
        end
    end
    |> round_or_not!
  end

  defp round_or_not!(value) do
    if Kernel.round(value) == value do
      Kernel.round(value)
    else
      Float.round(value, 8)
    end
  end

  def apply_precision(integer, hash, precision) do
    precision = if is_nil(precision), do: 8, else: precision
    value = if String.length(hash) == 40, do: integer / :math.pow(10, precision), else: integer

    (value * 1.0)
    |> :erlang.float_to_binary(decimals: precision)
    |> String.trim_trailing("0")
    |> String.trim_trailing(".")
  end
end
