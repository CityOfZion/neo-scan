defmodule Neoscan.Notifications.NotificationsTest do
  use ExUnit.Case

  alias NeoscanNode.Notifications

  @limit_height Application.fetch_env!(:neoscan_node, :start_notifications)

  test "get_block_notifications/2" do
    assert [] = Notifications.get_block_notifications(1)

    assert [
             %{
               addr_from:
                 <<0, 89, 172, 121, 90, 221, 47, 215, 253, 163, 32, 179, 101, 231, 203, 246, 209,
                   186, 81, 187, 225, 61, 183, 88, 204>>,
               addr_to:
                 <<1, 59, 147, 221, 221, 92, 51, 136, 45, 131, 161, 222, 206, 145, 107, 128, 202,
                   105, 1, 93, 240, 11, 147, 227, 119>>,
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
                 <<0, 89, 172, 121, 90, 221, 47, 215, 253, 163, 32, 179, 101, 231, 203, 246, 209,
                   186, 81, 187, 225, 61, 183, 88, 204>>,
               addr_to:
                 <<0, 117, 154, 37, 232, 212, 142, 247, 179, 229, 30, 146, 91, 153, 27, 90, 179,
                   40, 44, 15, 111, 75, 52, 233, 91>>,
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
                 <<0, 89, 172, 121, 90, 221, 47, 215, 253, 163, 32, 179, 101, 231, 203, 246, 209,
                   186, 81, 187, 225, 61, 183, 88, 204>>,
               addr_to:
                 <<0, 223, 28, 45, 76, 41, 191, 181, 4, 89, 53, 113, 94, 1, 138, 122, 229, 175,
                   194, 132, 246, 166, 195, 50, 128>>,
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
                   <<1, 5, 118, 223, 163, 124, 130, 252, 44, 62, 147, 100, 49, 229, 69, 43, 148,
                     252, 129, 36, 235, 137, 77, 96, 174>>,
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
