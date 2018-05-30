defmodule NeoPrice.Cryptocompare.HelperTest do
  @moduledoc ""
  use ExUnit.Case

  test "retry_get/1 ok" do
    assert Neoprice.Cryptocompare.Helper.retry_get("successful") == {:ok, :ok}
  end

  test "retry_get/1 error" do
    assert Neoprice.Cryptocompare.Helper.retry_get("error") == {:error, :retry_max}
  end
end
