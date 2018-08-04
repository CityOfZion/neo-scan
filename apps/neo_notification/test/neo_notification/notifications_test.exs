defmodule NeoNotificationTest do
  use ExUnit.Case

  @notification_url Application.fetch_env!(:neo_notification, :notification_url_test)

  test "get_block_notifications/2" do
    assert {:ok, []} = NeoNotification.get_block_notifications(@notification_url, 1)

    assert {:ok,
            [
              %{
                addr_from: <<0>>,
                addr_to:
                  <<23, 133, 16, 77, 11, 27, 194, 133, 40, 155, 23, 113, 122, 111, 172, 170, 44,
                    189, 23, 18, 179, 85, 111, 82, 40>>,
                amount: 5_065_200_000_000_000,
                block: 1_444_843,
                contract:
                  <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133,
                    112, 107, 29, 249>>,
                notify_type: :transfer,
                transaction_hash:
                  <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254,
                    241, 118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
                type: "SmartContract.Runtime.Notify"
              },
              %{
                addr_from: <<0>>,
                addr_to:
                  <<23, 19, 11, 137, 29, 197, 52, 27, 206, 249, 60, 7, 127, 199, 236, 86, 36, 238,
                    135, 118, 248, 220, 36, 91, 182>>,
                amount: 9_096_780_000_000_000,
                block: 1_444_843,
                contract:
                  <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133,
                    112, 107, 29, 249>>,
                notify_type: :transfer,
                transaction_hash:
                  <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254,
                    241, 118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
                type: "SmartContract.Runtime.Notify"
              },
              %{
                addr_from: <<0>>,
                addr_to:
                  <<23, 69, 188, 181, 144, 227, 224, 251, 0, 16, 215, 191, 222, 111, 124, 211,
                    147, 130, 253, 134, 233, 108, 158, 22, 159>>,
                amount: 3_500_000_000_000_000,
                block: 1_444_843,
                contract:
                  <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133,
                    112, 107, 29, 249>>,
                notify_type: :transfer,
                transaction_hash:
                  <<201, 32, 178, 25, 46, 116, 237, 164, 202, 97, 64, 81, 8, 19, 170, 64, 254,
                    241, 118, 125, 0, 193, 82, 170, 111, 128, 39, 194, 75, 223, 20, 242>>,
                type: "SmartContract.Runtime.Notify"
              }
            ]} == NeoNotification.get_block_notifications(@notification_url, 1_444_843)

    assert 2771 ==
             Enum.count(
               elem(NeoNotification.get_block_notifications(@notification_url, 1_444_902), 1)
             )
  end

  test "get_tokens/2" do
    assert {:ok,
            [
              %{
                block: 1_982_259,
                contract: %{
                  properties: %{"dynamic_invoke" => false, "storage" => true},
                  version: 0,
                  author: "The Orbis Team",
                  code_version: "2.00",
                  email: "admin@orbismesh.com",
                  hash:
                    <<14, 134, 164, 5, 136, 247, 21, 252, 175, 122, 205, 24, 18, 213, 10, 244,
                      120, 230, 233, 23>>,
                  name: "Orbis",
                  parameters: ["String", "Array"],
                  return_type: "ByteArray",
                  script: <<18>>
                },
                token: %{
                  decimals: 8,
                  contract_address:
                    <<23, 23, 233, 230, 120, 244, 10, 213, 18, 24, 205, 122, 175, 252, 21, 247,
                      136, 5, 164, 134, 14, 67, 133, 250, 73>>,
                  name: "Orbis",
                  script_hash:
                    <<14, 134, 164, 5, 136, 247, 21, 252, 175, 122, 205, 24, 18, 213, 10, 244,
                      120, 230, 233, 23>>,
                  symbol: "OBT"
                },
                transaction_hash:
                  <<68, 155, 111, 142, 48, 94, 167, 155, 201, 193, 12, 220, 9, 108, 255, 10, 43,
                    93, 122, 185, 79, 228, 43, 140, 133, 204, 178, 74, 80, 11, 174, 235>>,
                type: nil
              },
              %{
                block: 2_120_075,
                contract: %{
                  author: "Loopring",
                  code_version: "1",
                  email: "@",
                  hash:
                    <<6, 250, 139, 233, 182, 96, 157, 150, 62, 143, 198, 57, 119, 185, 248, 220,
                      95, 16, 137, 95>>,
                  name: "lrnToken",
                  parameters: ["String", "Array"],
                  properties: %{"dynamic_invoke" => false, "storage" => true},
                  return_type: "ByteArray",
                  script: nil,
                  version: 0
                },
                token: %{
                  contract_address:
                    <<23, 95, 137, 16, 95, 220, 248, 185, 119, 57, 198, 143, 62, 150, 157, 96,
                      182, 233, 139, 250, 6, 243, 22, 97, 79>>,
                  decimals: 8,
                  name: "Loopring Neo Token",
                  script_hash:
                    <<6, 250, 139, 233, 182, 96, 157, 150, 62, 143, 198, 57, 119, 185, 248, 220,
                      95, 16, 137, 95>>,
                  symbol: "LRN"
                },
                transaction_hash:
                  <<215, 217, 124, 63, 198, 0, 238, 34, 23, 15, 42, 102, 169, 181, 200, 58, 33,
                    34, 232, 192, 44, 101, 23, 216, 28, 153, 211, 239, 237, 248, 134, 211>>,
                type: nil
              }
            ]} == NeoNotification.get_tokens(@notification_url)
  end

  test "get_block_transfers/2" do
    assert 3 ==
             Enum.count(
               elem(NeoNotification.get_block_transfers(@notification_url, 1_444_843), 1)
             )
  end

  test "get_current_height/2" do
    assert {:ok, 2_400_000} == NeoNotification.get_current_height(@notification_url)
  end
end
