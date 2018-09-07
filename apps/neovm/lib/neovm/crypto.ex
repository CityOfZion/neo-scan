defmodule NeoVM.Crypto do
  @moduledoc """
    Convenience cryto functions for the neovm
  """

  @p 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
  @a 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC
  @b 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B

  def ripemd160(bin), do: :crypto.hash(:ripemd160, bin)
  def sha256(bin), do: :crypto.hash(:sha256, bin)
  def sha1(bin), do: :crypto.hash(:sha, bin)

  def hash160(bin) do
    bin
    |> sha256
    |> ripemd160
  end

  def hash256(bin) do
    bin
    |> sha256
    |> sha256
  end

  def convert_signature(signature) do
    {r, s} = :erlang.split_binary(signature, div(byte_size(signature), 2))
    sig_value = {:"ECDSA-Sig-Value", :crypto.bytes_to_integer(r), :crypto.bytes_to_integer(s)}
    :public_key.der_encode(:"ECDSA-Sig-Value", sig_value)
  end

  def decompress_public_key(<<prefix, x2::binary>> = public_key)
      when byte_size(public_key) == 33 do
    x = :crypto.bytes_to_integer(x2)
    beta = :crypto.bytes_to_integer(:crypto.mod_pow(x * x * x + @a * x + @b, div(@p + 1, 4), @p))

    y =
      if rem(beta + prefix, 2) != 0 do
        @p - beta
      else
        beta
      end

    <<0x04, x2::binary, :binary.encode_unsigned(y)::binary>>
  end

  def decompress_public_key(public_key) when byte_size(public_key) == 65, do: public_key

  def verify_signature(message, signature, public_key) do
    try do
      signature_der = convert_signature(signature)
      pub_key_decompressed = decompress_public_key(public_key)
      :crypto.verify(:ecdsa, :sha256, message, signature_der, [pub_key_decompressed, :secp256r1])
    catch
      _, _ ->
        false
    end
  end
end
