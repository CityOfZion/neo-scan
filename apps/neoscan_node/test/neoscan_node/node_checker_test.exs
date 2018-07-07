defmodule NeoscanNode.NodeCheckerTest do
  use ExUnit.Case

  alias NeoscanNode.NodeChecker

  test "sync/0" do
    NodeChecker.sync()
  end
end
