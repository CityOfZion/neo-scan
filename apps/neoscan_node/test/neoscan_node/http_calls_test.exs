defmodule Neoscan.HttpCalls.HttpCallsTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  alias NeoscanNode.HttpCalls

  @node_url "http://seed1.cityofzion.io:8080"
  @token_url "http://notifications1.neeeo.org/v1/tokens"

  test "post/3" do
    assert {:ok, _} = HttpCalls.post(@node_url, "getblock", [0, 1])
    assert {:error, _} = HttpCalls.post(@node_url, "getblockerror", [0, 1])
  end

  test "get/3" do
    assert {:ok, [_ | _], _} = HttpCalls.get(@token_url)

    assert capture_log(fn ->
             assert {:error, _} = HttpCalls.get("error")
           end) =~ ":error error"
  end
end
