defmodule NeoscanSync.Genstage.ProducerTest do
  use ExUnit.Case

  alias NeoscanSync.Producer

  test "handle_demand/2" do
    assert {:noreply, [%{"index" => 1}, %{"index" => 2}], {2, 0}} =
             Producer.handle_demand(2, {0, nil})
  end

  test "handle_info(:fetch_more, {counter, pending_demand})" do
    assert {:noreply, [%{"index" => 1}, %{"index" => 2}], {2, 0}} =
             Producer.handle_info(:fetch_more, {0, 2})
  end
end
