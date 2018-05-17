defmodule NeoscanNodeTest do
  use ExUnit.Case

  test "get_nodes/0" do
    assert is_list(NeoscanNode.get_nodes())
  end

  test "get_height/0" do
    {:ok, height} = NeoscanNode.get_height()
    assert is_number(height)
  end

  test "get_data/0" do
    [{url, height} | _] = NeoscanNode.get_data()
    assert is_bitstring(url) and is_number(height)
  end

  test "add_notifications/2" do
    assert %{"transfers" => []} = NeoscanNode.add_notifications(%{}, 0)
  end

  test "restart/0" do
    assert {:ok, _} = NeoscanNode.restart()
  end
end
