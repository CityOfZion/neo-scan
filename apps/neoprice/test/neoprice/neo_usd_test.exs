defmodule NeoPrice.NeoUsdTest do
  @moduledoc "tests on NeoUsd"
  use ExUnit.Case
  alias Neoprice.NeoUsd

  setup_all do
    wait()
  end

  def wait do
    if is_not_empty_map(NeoUsd.get_1_day()) do
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
    assert is_not_empty_map(NeoUsd.get_all())
  end

  test "get_3_month/0" do
    assert is_not_empty_map(NeoUsd.get_3_month())
  end

  test "get_1_month/0" do
    assert is_not_empty_map(NeoUsd.get_1_month())
  end

  test "get_1_week/0" do
    assert is_not_empty_map(NeoUsd.get_1_week())
  end

  test "get_1_day/0" do
    assert is_not_empty_map(NeoUsd.get_1_day())
  end

  test "price/0" do
    assert is_number(NeoUsd.price())
  end

  test "last_price_full/0" do
    assert is_not_empty_map(NeoUsd.last_price_full())
  end

  test "from_symbol/0" do
    assert "NEO" == NeoUsd.from_symbol()
  end

  test "to_symbol/0" do
    assert "USD" == NeoUsd.to_symbol()
  end

  test "config/0" do
    assert is_list(NeoUsd.config())
  end

  test "start_day/0" do
    assert 1_500_000_000 == NeoUsd.start_day()
  end
end
