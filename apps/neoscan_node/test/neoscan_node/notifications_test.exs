defmodule Neoscan.Notifications.NotificationsTest do
  use ExUnit.Case

  alias NeoscanNode.Notifications

  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  test "get_block_notifications/2" do
    assert [] = Notifications.get_block_notifications(1)

    assert [
             %{
               addr_from:
                 <<23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 86, 123, 108,
                   90>>,
               addr_to:
                 <<23, 133, 16, 77, 11, 27, 194, 133, 40, 155, 23, 113, 122, 111, 172, 170, 44,
                   189, 23, 18, 179, 85, 111, 82, 40>>,
               amount: 5_065_200_000_000_000,
               block: 1_444_843,
               contract:
                 <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133, 112,
                   107, 29, 249>>,
               notify_type: :transfer,
               transaction_hash:
                 <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254, 241,
                   118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
               type: "SmartContract.Runtime.Notify"
             },
             %{
               addr_from:
                 <<23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 86, 123, 108,
                   90>>,
               addr_to:
                 <<23, 19, 11, 137, 29, 197, 52, 27, 206, 249, 60, 7, 127, 199, 236, 86, 36, 238,
                   135, 118, 248, 220, 36, 91, 182>>,
               amount: 9_096_780_000_000_000,
               block: 1_444_843,
               contract:
                 <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133, 112,
                   107, 29, 249>>,
               notify_type: :transfer,
               transaction_hash:
                 <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254, 241,
                   118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
               type: "SmartContract.Runtime.Notify"
             },
             %{
               addr_from:
                 <<23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 86, 123, 108,
                   90>>,
               addr_to:
                 <<23, 69, 188, 181, 144, 227, 224, 251, 0, 16, 215, 191, 222, 111, 124, 211, 147,
                   130, 253, 134, 233, 108, 158, 22, 159>>,
               amount: 3_500_000_000_000_000,
               block: 1_444_843,
               contract:
                 <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133, 112,
                   107, 29, 249>>,
               notify_type: :transfer,
               transaction_hash:
                 <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254, 241,
                   118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
               type: "SmartContract.Runtime.Notify"
             }
           ] == Notifications.get_block_notifications(1_444_843)
  end

  test "get_token_notifications/1" do
    assert [
             %{
               block: 2_120_069,
               contract: %{
                 author: "Loopring",
                 code_version: "1",
                 email: "@",
                 hash:
                   <<203, 159, 59, 124, 111, 177, 207, 44, 19, 164, 6, 55, 193, 137, 189, 208,
                     102, 162, 114, 180>>,
                 name: "lrnToken",
                 parameters: "0710",
                 properties: %{
                   "dynamic_invoke" => false,
                   "storage" => true
                 },
                 return_type: 5,
                 script: "",
                 version: 0
               },
               token: %{
                 contract_address:
                   <<23, 95, 137, 16, 95, 220, 248, 185, 119, 57, 198, 143, 62, 150, 157, 96, 182,
                     233, 139, 250, 6, 243, 22, 97, 79>>,
                 decimals: 8,
                 name: "Loopring Neo Token",
                 script_hash:
                   <<6, 250, 139, 233, 182, 96, 157, 150, 62, 143, 198, 57, 119, 185, 248, 220,
                     95, 16, 137, 95>>,
                 symbol: "LRN"
               },
               transaction_hash:
                 <<231, 8, 163, 231, 105, 125, 137, 185, 211, 119, 83, 153, 220, 238, 34, 255,
                   255, 237, 150, 2, 196, 7, 121, 104, 166, 110, 5, 154, 76, 204, 190, 37>>,
               type: "SmartContract.Contract.Create"
             }
           ] == Notifications.get_token_notifications()
  end

  test "add_notifications/2" do
    assert [] = Notifications.get_transfer_block_notifications(0)
    assert [] = Notifications.get_transfer_block_notifications(@limit_height + 1)
    assert 3 == Enum.count(Notifications.get_transfer_block_notifications(1_444_843))
  end
end
