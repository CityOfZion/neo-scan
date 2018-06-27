defmodule Neoscan.HelperTest do
  use Neoscan.DataCase

  alias Neoscan.Helpers
  alias Neoscan.Explanations

  test "Explanations.get/1" do
    assert "hash of a public address" == Explanations.get("address_hash")
    assert "failed to find this explanation" == Explanations.get("randomstuff")
  end

  test "round_or_not/1" do
    assert 12.3 == Helpers.round_or_not(12.3)
    assert 12 == Helpers.round_or_not(12)
    assert 12.3 == Helpers.round_or_not("12.3")
  end

  test "apply_precision/3" do
    assert "0.000001234567" ==
             Helpers.apply_precision(1_234_567, "1234567890123456789012345678901234567890", 12)

    assert "1234567" == Helpers.apply_precision(1_234_567, "1", 12)
  end
end
