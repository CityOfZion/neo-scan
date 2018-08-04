defmodule NeoscanSync.TokenSyncerTest do
  use NeoscanSync.DataCase

  alias NeoscanSync.TokenSyncer

  test "sync_tokens/0" do
    assert {2, nil} == TokenSyncer.sync_tokens()
  end
end
