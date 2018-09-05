defmodule NeoscanWeb.Controllers.Helpers do
  @moduledoc false

  defmodule DecimalTransformer do
    defstruct value: nil

    defp new(nil), do: nil
    defp new(value), do: %DecimalTransformer{value: value}

    def replace(
          %{
            :net_fee => %Decimal{},
            :sys_fee => %Decimal{},
            :vin => vin,
            :vouts => vouts,
            :claims => claims
          } = transaction
        )
        when is_list(vin) and is_list(vouts) and is_list(claims) do
      transaction
      |> Map.update!(:net_fee, &new/1)
      |> Map.update!(:sys_fee, &new/1)
      |> Map.update!(:vin, &replace/1)
      |> Map.update!(:vouts, &replace/1)
      |> Map.update!(:claims, &replace/1)
    end

    def replace(%{:balance => balance} = balances) when is_list(balance) do
      balances |> Map.update!(:balance, &replace/1)
    end

    def replace(%{:amount => %Decimal{}, :unspent => unspent} = balance) when is_list(unspent) do
      balance
      |> Map.update!(:amount, &new/1)
      |> Map.update!(:unspent, &replace/1)
    end

    def replace(%{:unclaimed => %Decimal{}, :claimable => c} = map) when is_list(c) do
      map
      |> Map.update!(:unclaimed, &new/1)
      |> Map.update!(:claimable, &replace/1)
    end

    def replace(
          %{
            :generated => %Decimal{},
            :sys_fee => %Decimal{},
            :unclaimed => %Decimal{},
            :value => %Decimal{}
          } = map
        ) do
      map
      |> Map.update!(:generated, &new/1)
      |> Map.update!(:sys_fee, &new/1)
      |> Map.update!(:unclaimed, &new/1)
      |> Map.update!(:value, &new/1)
    end

    def replace(%{:value => %Decimal{}} = map), do: Map.update!(map, :value, &new/1)
    def replace(%{:unclaimed => %Decimal{}} = map), do: Map.update!(map, :unclaimed, &new/1)
    def replace(list) when is_list(list), do: Enum.map(list, &replace/1)
    def replace(value), do: value

    if Code.ensure_loaded?(Poison) do
      defimpl Poison.Encoder, for: DecimalTransformer do
        def encode(transformer, _options) do
          # TODO: Replace to Decimal.to_string(num, :xsd) for the next release of v1.5.0
          candidate = Decimal.to_string(transformer.value, :normal)

          if !Decimal.nan?(transformer.value) and !Decimal.inf?(transformer.value) and
               !String.contains?(candidate, ".") do
            "#{candidate}.0"
          else
            candidate
          end
        end
      end
    end
  end

  defmacro if_valid_query(conn, params, specs, do: block) do
    var = Macro.var(:parsed, nil)

    quote do
      unquote(var) = NeoscanWeb.Controllers.Helpers.parse(unquote(params), unquote(specs))

      case unquote(var) do
        %{errors: _} ->
          redirect(unquote(conn), to: home_path(unquote(conn), :index))

        _ ->
          unquote(block)
      end
    end
  end

  defmacro if_valid_query_json(conn, params, specs, do: block) do
    var = Macro.var(:parsed, nil)

    quote do
      unquote(var) = NeoscanWeb.Controllers.Helpers.parse(unquote(params), unquote(specs))

      case unquote(var) do
        %{errors: errors} ->
          json(put_status(unquote(conn), :bad_request), %{errors: errors})

        _ ->
          block = unquote(block) |> DecimalTransformer.replace()

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
      _, _ ->
        error = "#{name} is not a valid #{type}"
        Map.update(parsed, :errors, [error], &[error | &1])
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
