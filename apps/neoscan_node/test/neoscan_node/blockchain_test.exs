defmodule Neoscan.Blockchain.BlockchainTest do
  use ExUnit.Case

  alias NeoscanNode.Blockchain

  test "get_block_by_height/2" do
    assert {
             :ok,
             %{
               version: 0,
               confirmations: 2_326_310,
               hash:
                 <<212, 37, 97, 227, 211, 14, 21, 190, 100, 0, 182, 223, 47, 50, 142, 2, 210, 191,
                   99, 84, 196, 29, 206, 67, 59, 197, 118, 135, 200, 33, 68, 191>>,
               index: 0,
               merkle_root:
                 <<128, 63, 244, 171, 227, 234, 101, 51, 188, 192, 190, 87, 78, 250, 2, 248, 58,
                   232, 253, 198, 81, 200, 121, 5, 107, 13, 155, 227, 54, 192, 27, 244>>,
               next_block_hash:
                 <<215, 130, 219, 138, 56, 176, 238, 160, 215, 57, 78, 15, 0, 124, 97, 199, 23,
                   152, 134, 117, 120, 199, 124, 56, 124, 8, 17, 57, 3, 148, 108, 201>>,
               next_consensus:
                 <<0, 252, 132, 199, 151, 248, 102, 110, 40, 8, 124, 5, 90, 36, 147, 106, 152,
                   117, 124, 240, 113, 101, 167, 24, 85>>,
               nonce: <<0, 0, 0, 0, 124, 43, 172, 29>>,
               previous_block_hash:
                 <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                   0, 0, 0, 0, 0, 0>>,
               script: %{
                 "invocation" => "",
                 "verification" => "51"
               },
               size: 401,
               time: DateTime.from_unix!(1_468_595_301),
               tx: [
                 %{
                   asset: nil,
                   block_hash:
                     <<212, 37, 97, 227, 211, 14, 21, 190, 100, 0, 182, 223, 47, 50, 142, 2, 210,
                       191, 99, 84, 196, 29, 206, 67, 59, 197, 118, 135, 200, 33, 68, 191>>,
                   block_time: DateTime.from_unix!(1_468_595_301),
                   attributes: [],
                   hash:
                     <<251, 91, 215, 43, 45, 103, 146, 215, 93, 194, 241, 8, 79, 250, 158, 159,
                       112, 202, 133, 84, 60, 113, 122, 107, 19, 217, 149, 155, 69, 42, 87, 214>>,
                   net_fee: 0.0,
                   nonce: 2_083_236_893,
                   scripts: [],
                   size: 10,
                   sys_fee: 0.0,
                   type: :miner_transaction,
                   version: 0,
                   vins: [],
                   vouts: []
                 },
                 %{
                   asset: %{
                     admin:
                       <<1, 183, 246, 168, 203, 53, 167, 52, 27, 242, 70, 36, 245, 27, 177, 181,
                         70, 253, 142, 212, 74, 37, 91, 129, 38>>,
                     amount: 100_000_000,
                     available: nil,
                     expiration: nil,
                     frozen: nil,
                     issuer:
                       <<1, 183, 246, 168, 203, 53, 167, 52, 27, 242, 70, 36, 245, 27, 177, 181,
                         70, 253, 142, 212, 74, 37, 91, 129, 38>>,
                     name: [
                       %{"lang" => "zh-CN", "name" => "小蚁股"},
                       %{"lang" => "en", "name" => "AntShare"}
                     ],
                     owner: "00",
                     precision: 0,
                     transaction_hash:
                       <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147,
                         144, 175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124,
                         155>>,
                     type: :governing_token,
                     version: nil
                   },
                   block_hash:
                     <<212, 37, 97, 227, 211, 14, 21, 190, 100, 0, 182, 223, 47, 50, 142, 2, 210,
                       191, 99, 84, 196, 29, 206, 67, 59, 197, 118, 135, 200, 33, 68, 191>>,
                   block_time: DateTime.from_unix!(1_468_595_301),
                   attributes: [],
                   hash:
                     <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147,
                       144, 175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124,
                       155>>,
                   net_fee: 0.0,
                   nonce: nil,
                   scripts: [],
                   size: 107,
                   sys_fee: 0.0,
                   type: :register_transaction,
                   version: 0,
                   vins: [],
                   vouts: []
                 },
                 %{
                   asset: %{
                     admin:
                       <<1, 98, 132, 10, 63, 81, 15, 202, 210, 241, 19, 220, 164, 40, 24, 86, 57,
                         53, 13, 230, 50, 31, 12, 89, 155>>,
                     amount: 100_000_000,
                     available: nil,
                     expiration: nil,
                     frozen: nil,
                     issuer:
                       <<1, 98, 132, 10, 63, 81, 15, 202, 210, 241, 19, 220, 164, 40, 24, 86, 57,
                         53, 13, 230, 50, 31, 12, 89, 155>>,
                     name: [
                       %{"lang" => "zh-CN", "name" => "小蚁币"},
                       %{"lang" => "en", "name" => "AntCoin"}
                     ],
                     owner: "00",
                     precision: 8,
                     transaction_hash:
                       <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16,
                         132, 227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45,
                         231>>,
                     type: :utility_token,
                     version: nil
                   },
                   block_hash:
                     <<212, 37, 97, 227, 211, 14, 21, 190, 100, 0, 182, 223, 47, 50, 142, 2, 210,
                       191, 99, 84, 196, 29, 206, 67, 59, 197, 118, 135, 200, 33, 68, 191>>,
                   block_time: DateTime.from_unix!(1_468_595_301),
                   attributes: [],
                   hash:
                     <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16,
                       132, 227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45,
                       231>>,
                   net_fee: 0.0,
                   nonce: nil,
                   scripts: [],
                   size: 106,
                   sys_fee: 0.0,
                   type: :register_transaction,
                   version: 0,
                   vins: [],
                   vouts: []
                 },
                 %{
                   asset: nil,
                   block_hash:
                     <<212, 37, 97, 227, 211, 14, 21, 190, 100, 0, 182, 223, 47, 50, 142, 2, 210,
                       191, 99, 84, 196, 29, 206, 67, 59, 197, 118, 135, 200, 33, 68, 191>>,
                   block_time: DateTime.from_unix!(1_468_595_301),
                   attributes: [],
                   hash:
                     <<54, 49, 246, 96, 36, 202, 111, 91, 3, 61, 126, 8, 9, 235, 153, 52, 67, 55,
                       72, 48, 2, 90, 249, 4, 251, 81, 176, 51, 79, 18, 124, 218>>,
                   net_fee: 0.0,
                   nonce: nil,
                   scripts: [%{"invocation" => "", "verification" => "51"}],
                   size: 69,
                   sys_fee: 0.0,
                   type: :issue_transaction,
                   version: 0,
                   vins: [],
                   vouts: [
                     %{
                       address:
                         <<1, 5, 97, 218, 145, 187, 223, 102, 47, 180, 214, 177, 16, 105, 16, 81,
                           232, 183, 96, 14, 28, 190, 142, 221, 218>>,
                       asset:
                         <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229,
                           147, 144, 175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255,
                           124, 155>>,
                       n: 0,
                       value: 100_000_000
                     }
                   ]
                 }
               ]
             }
           } == Blockchain.get_block_by_height(0)

    assert {:ok, %{index: 2_120_069}} = Blockchain.get_block_by_height(2_120_069)
  end

  test "get_block_by_hash/2" do
    block_0_hash = "d42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf"
    block_1_hash = "d782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9"
    assert {:ok, %{index: 0}} = Blockchain.get_block_by_hash(block_0_hash)
    assert {:ok, %{index: 1}} = Blockchain.get_block_by_hash(block_1_hash)
  end

  test "get_current_height/1" do
    {:ok, height} = Blockchain.get_current_height()
    assert 200 == height
  end

  test "get_transaction/2" do
    txid = "0x9e9526615ee7d460ed445c873c4af91bf7bfcc67e6e43feaf051b962a6df0a98"

    assert {
             :ok,
             %{
               asset: nil,
               attributes: [],
               block_hash:
                 <<213, 0, 206, 91, 206, 23, 53, 30, 158, 90, 36, 131, 52, 153, 207, 128, 242,
                   217, 136, 130, 121, 60, 19, 183, 187, 242, 33, 255, 50, 164, 44, 205>>,
               block_time: DateTime.from_unix!(1_476_647_836),
               hash:
                 <<158, 149, 38, 97, 94, 231, 212, 96, 237, 68, 92, 135, 60, 74, 249, 27, 247,
                   191, 204, 103, 230, 228, 63, 234, 240, 81, 185, 98, 166, 223, 10, 152>>,
               net_fee: 0.0,
               nonce: 3_576_443_283,
               scripts: [],
               size: 10,
               sys_fee: 0.0,
               type: :miner_transaction,
               version: 0,
               vins: [],
               vouts: []
             }
           } == Blockchain.get_transaction(txid)
  end

  test "get_asset/2" do
    txid = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"

    assert {
             :ok,
             %{
               admin:
                 <<1, 183, 246, 168, 203, 53, 167, 52, 27, 242, 70, 36, 245, 27, 177, 181, 70,
                   253, 142, 212, 74, 37, 91, 129, 38>>,
               amount: 100_000_000,
               available: 100_000_000,
               expiration: 4_000_000,
               frozen: false,
               issuer:
                 <<1, 183, 246, 168, 203, 53, 167, 52, 27, 242, 70, 36, 245, 27, 177, 181, 70,
                   253, 142, 212, 74, 37, 91, 129, 38>>,
               name: [
                 %{"lang" => "zh-CN", "name" => "\\u5C0F\\u8681\\u80A1"},
                 %{"lang" => "en", "name" => "AntShare"}
               ],
               owner: "00",
               precision: 0,
               transaction_hash:
                 <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                   175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>,
               type: :governing_token,
               version: 0
             }
           } == Blockchain.get_asset(txid)
  end

  test "get_contract/2" do
    contract_hash = "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"

    assert {
             :ok,
             %{
               author: "Red Pulse",
               code_version: "1.0",
               email: "rpx@red-pulse.com",
               hash:
                 <<236, 198, 178, 13, 60, 202, 193, 238, 158, 241, 9, 175, 90, 124, 219, 133, 112,
                   107, 29, 249>>,
               name: "RPX Sale",
               parameters: ["String", "Array"],
               properties: %{
                 "dynamic_invoke" => false,
                 "storage" => true
               },
               return_type: "ByteArray",
               script: <<1, 31>>,
               version: 0
             }
           } = Blockchain.get_contract(contract_hash)
  end
end
