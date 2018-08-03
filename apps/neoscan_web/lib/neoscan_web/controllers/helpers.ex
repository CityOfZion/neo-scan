defmodule NeoscanWeb.Controllers.Helpers do
  @moduledoc false

  defmacro if_valid_params(conn, params, specs, do: block) do
    var = Macro.var(:parsed, nil)

    quote do
      unquote(var) = NeoscanWeb.Controllers.Helpers.parse(unquote(params), unquote(specs))

      case unquote(var) do
        %{errors: errors} ->
          json(unquote(conn), %{errors: errors})

        _ ->
          block = unquote(block)

          if is_nil(block) do
            json(put_status(unquote(conn), :not_found), %{errors: ["object not found"]})
          else
            json(unquote(conn), block)
          end
      end
    end
  end

  def parse(params, specs), do: parse(params, specs, %{})

  defp parse(_, [], parsed), do: parsed

  defp parse(params, [{name, opts} | rest], parsed) do
    elem = Map.get(params, to_string(name))
    parse(params, rest, update_parsed(parsed, elem, opts, name))
  end

  defp update_parsed(parsed, nil, %{default: default}, name) do
    Map.put(parsed, name, default)
  end

  defp update_parsed(parsed, value, %{type: type}, name) do
    try do
      Map.put(parsed, name, parse_type(value, type))
    catch
      _ ->
        Map.update(parsed, :errors, &["#{name} is not a valid #{type}" | &1], [])
    end
  end

  defp parse_type(address, :base58), do: Base58.decode(address)
  defp parse_type(integer, :integer), do: String.to_integer(integer)
  defp parse_type(value, :base16), do: Base.decode16!(value, case: :mixed)

  defp parse_type(value, :integer_or_base16) do
    case Integer.parse(value) do
      {integer, ""} ->
        integer

      _ ->
        Base.decode16!(value, case: :mixed)
    end
  end
end
