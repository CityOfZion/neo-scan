defmodule NeoNode.HttpCallsTest do
  use ExUnit.Case

  alias NeoNode.HttpCalls

  @fake_node_url "http://fakenode"

  test "post/3" do
    assert {:ok, _} = HttpCalls.post(@fake_node_url, "getblock", [0, 1])
    assert {:error, _} = HttpCalls.post(@fake_node_url, "getblockerror", [0, 1])
  end
end
