defmodule Neoscan.Helpers.ExplanationsTest do
  use Neoscan.DataCase

  alias Neoscan.Explanations

  test "get/1" do
    assert "hash of a public address" == Explanations.get("address_hash")
    assert "failed to find this explanation" == Explanations.get("randomstuff")
  end
end
