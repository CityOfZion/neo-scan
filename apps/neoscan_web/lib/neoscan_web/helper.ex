defmodule NeoscanWeb.Helper do
  def safe_decode_16(value) do
    case Base.decode16(value, case: :mixed) do
      :error ->
        <<0>>

      {:ok, value} ->
        value
    end
  end

  def safe_decode_58(value) do
    try do
      Base58.decode(value)
    rescue
      _ -> <<0>>
    catch
      _ -> <<0>>
    end
  end
end
