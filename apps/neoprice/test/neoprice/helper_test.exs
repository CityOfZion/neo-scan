defmodule NeoPrice.HelperTest do
  @moduledoc ""
  use ExUnit.Case

  import Mock

  test "retry_get/1 ok" do
    with_mock Neoprice.Helper.Request, [get: fn (_url) -> {:ok, :ok} end] do
    assert Neoprice.Helper.retry_get("random") == {:ok, :ok}
    end
  end

  test "retry_get/1 error" do
    with_mock Neoprice.Helper.Request, [get: fn (_url) -> {:error, :error} end] do
      assert Neoprice.Helper.retry_get("random") == {:error, :retry_max}
    end
  end
end
