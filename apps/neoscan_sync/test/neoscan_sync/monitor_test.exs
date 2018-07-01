defmodule NeoscanSync.MonitorTest do
  use NeoscanSync.DataCase

  test "write/1" do
    assert :ok ==
             Monitor.write(
               download_blocks_count: 10,
               download_blocks_time: 300_000,
               insert_blocks_time: 20_000,
               insert_blocks_count: 5
             )
  end
end
