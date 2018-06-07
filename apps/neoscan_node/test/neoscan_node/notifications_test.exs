defmodule Neoscan.Notifications.NotificationsTest do
  use ExUnit.Case

  alias NeoscanNode.Notifications

  @notification_seeds Application.fetch_env!(:neoscan_node, :notification_seeds)
  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  test "get_block_notifications/2" do
    assert [] = Notifications.get_block_notifications(1)

    assert {:error, "no working rpc endpoint"} =
             Notifications.get_block_notifications(1, @notification_seeds)
  end

  test "get_token_notifications/1" do
    assert is_list(Notifications.get_token_notifications([]))
  end

  test "add_notifications/2" do
    assert %{"transfers" => []} = Notifications.add_notifications(%{}, 0)
    assert %{"transfers" => []} = Notifications.add_notifications(%{}, @limit_height + 1)
    Notifications.add_notifications(%{}, 1_444_843)
  end
end
