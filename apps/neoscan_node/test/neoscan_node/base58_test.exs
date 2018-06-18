defmodule Base58Test do
  use ExUnit.Case

  test "base58" do
    random_bin = :crypto.strong_rand_bytes(32)
    assert random_bin == Base58.decode(Base58.encode(random_bin))
  end
end
