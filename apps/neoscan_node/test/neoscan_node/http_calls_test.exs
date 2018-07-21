defmodule Neoscan.HttpCalls.HttpCallsTest do
  use ExUnit.Case

  alias NeoscanNode.HttpCalls

  @notification_url Application.fetch_env!(:neoscan_node, :notification_seeds) |> List.first()
  @node_url Application.fetch_env!(:neoscan_node, :seeds) |> List.first()
  @token_url "#{@notification_url}/tokens?page=1"

  test "post/3" do
    assert {:ok, _} = HttpCalls.post(@node_url, "getblock", [0, 1])
    assert {:error, _} = HttpCalls.post(@node_url, "getblockerror", [0, 1])
  end

  test "get/3" do
    assert {:ok, [_ | _], _, _} = HttpCalls.get(@token_url)
    assert {:error, _} = HttpCalls.get("error")
  end
end
