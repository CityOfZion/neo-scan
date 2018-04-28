defmodule NeoPrice.GasUsdTest do
  @moduledoc "tests on GasUsd"
  use ExUnit.Case
  alias Neoprice.GasUsd

  setup_all do
    wait()
  end

  def wait do
    if is_not_empty_map(GasUsd.get_1_day()) do
      :ok
    else
      Process.sleep(1000)
      wait()
    end
  end

  defp is_not_empty_map(map) do
    is_map(map) and map != %{}
  end

  test "get_all/0" do
    assert is_not_empty_map(GasUsd.get_all())
  end

  test "get_3_month/0" do
    assert is_not_empty_map(GasUsd.get_3_month())
  end

  test "get_1_month/0" do
    assert is_not_empty_map(GasUsd.get_1_month())
  end

  test "get_1_week/0" do
    assert is_not_empty_map(GasUsd.get_1_week())
  end

  test "get_1_day/0" do
    assert is_not_empty_map(GasUsd.get_1_day())
  end

  test "price/0" do
    assert is_number(GasUsd.price())
  end

  test "last_price_full/0" do
    assert is_not_empty_map(GasUsd.last_price_full())
  end
end
