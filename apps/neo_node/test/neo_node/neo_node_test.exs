defmodule NeoNodeTest do
  use ExUnit.Case

  @fake_node_url "http://fakenode"

  test "post/3" do
    assert {:ok, _} = NeoNode.post(@fake_node_url, "getblock", [0, 1])
    assert {:error, _} = NeoNode.post(@fake_node_url, "getblockerror", [0, 1])
  end

  test "get_block_by_height/2" do
    assert {
             :ok,
             %{
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
                 <<23, 89, 231, 93, 101, 43, 93, 56, 39, 191, 4, 193, 101, 187, 233, 239, 149,
                   204, 164, 191, 85, 165, 95, 119, 20>>,
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
                   claims: [],
                   hash:
                     <<251, 91, 215, 43, 45, 103, 146, 215, 93, 194, 241, 8, 79, 250, 158, 159,
                       112, 202, 133, 84, 60, 113, 122, 107, 19, 217, 149, 155, 69, 42, 87, 214>>,
                   net_fee: Decimal.new(0),
                   nonce: 2_083_236_893,
                   extra: %{
                     attributes: [],
                     contract: nil,
                     script: nil,
                     scripts: []
                   },
                   size: 10,
                   sys_fee: Decimal.new(0),
                   type: :miner_transaction,
                   version: 0,
                   vins: [],
                   vouts: []
                 },
                 %{
                   asset: %{
                     admin:
                       <<23, 218, 23, 69, 233, 181, 73, 189, 11, 250, 26, 86, 153, 113, 199, 126,
                         186, 48, 205, 90, 75, 177, 213, 88, 117>>,
                     amount: Decimal.new(100_000_000),
                     available: nil,
                     expiration: nil,
                     frozen: nil,
                     issuer:
                       <<23, 218, 23, 69, 233, 181, 73, 189, 11, 250, 26, 86, 153, 113, 199, 126,
                         186, 48, 205, 90, 75, 177, 213, 88, 117>>,
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
                   claims: [],
                   hash:
                     <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147,
                       144, 175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124,
                       155>>,
                   net_fee: Decimal.new(0),
                   nonce: nil,
                   extra: %{
                     attributes: [],
                     contract: nil,
                     script: nil,
                     scripts: []
                   },
                   size: 107,
                   sys_fee: Decimal.new(0),
                   type: :register_transaction,
                   version: 0,
                   vins: [],
                   vouts: []
                 },
                 %{
                   asset: %{
                     admin:
                       <<23, 159, 127, 208, 150, 211, 126, 210, 192, 227, 247, 240, 207, 201, 36,
                         190, 239, 79, 252, 235, 104, 117, 247, 96, 242>>,
                     amount: Decimal.new(100_000_000),
                     available: nil,
                     expiration: nil,
                     frozen: nil,
                     issuer:
                       <<23, 159, 127, 208, 150, 211, 126, 210, 192, 227, 247, 240, 207, 201, 36,
                         190, 239, 79, 252, 235, 104, 117, 247, 96, 242>>,
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
                   claims: [],
                   hash:
                     <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16,
                       132, 227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45,
                       231>>,
                   net_fee: Decimal.new(0),
                   nonce: nil,
                   extra: %{
                     attributes: [],
                     contract: nil,
                     script: nil,
                     scripts: []
                   },
                   size: 106,
                   sys_fee: Decimal.new(0),
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
                   claims: [],
                   hash:
                     <<54, 49, 246, 96, 36, 202, 111, 91, 3, 61, 126, 8, 9, 235, 153, 52, 67, 55,
                       72, 48, 2, 90, 249, 4, 251, 81, 176, 51, 79, 18, 124, 218>>,
                   net_fee: Decimal.new(0),
                   nonce: nil,
                   extra: %{
                     scripts: [%{"invocation" => "", "verification" => "51"}],
                     contract: nil,
                     attributes: [],
                     script: nil
                   },
                   size: 69,
                   sys_fee: Decimal.new(0),
                   type: :issue_transaction,
                   version: 0,
                   vins: [],
                   vouts: [
                     %{
                       address:
                         <<23, 95, 169, 157, 147, 48, 55, 117, 254, 80, 202, 17, 156, 50, 119, 89,
                           49, 62, 204, 250, 28, 241, 166, 178, 163>>,
                       asset:
                         <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229,
                           147, 144, 175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255,
                           124, 155>>,
                       n: 0,
                       value: Decimal.new(100_000_000)
                     }
                   ]
                 }
               ],
               version: 0
             }
           } == NeoNode.get_block_by_height(@fake_node_url, 0)

    assert {:ok, %{index: 2_120_069}} = NeoNode.get_block_by_height(@fake_node_url, 2_120_069)

    assert {:error, "error"} == NeoNode.get_block_by_height(@fake_node_url, 123_456)

    assert {:error, ":timeout #{@fake_node_url}"} ==
             NeoNode.get_block_by_height(@fake_node_url, 123_457)
  end

  test "get_block_by_hash/2" do
    block_0_hash = "d42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf"
    block_1_hash = "d782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9"
    assert {:ok, %{index: 0}} = NeoNode.get_block_by_hash(@fake_node_url, block_0_hash)
    assert {:ok, %{index: 1}} = NeoNode.get_block_by_hash(@fake_node_url, block_1_hash)

    assert {:error, %{"code" => -100, "message" => _message}} =
             NeoNode.get_block_by_hash(
               @fake_node_url,
               "0000000000000000000000000000000000000000000000000000000000000000"
             )
  end

  test "get_block_count/1" do
    {:ok, count} = NeoNode.get_block_count(@fake_node_url)
    assert 2_400_000 == count
  end

  test "get_version/1" do
    assert {:ok, {:csharp, "2.7.6.1/"}} == NeoNode.get_version(@fake_node_url)
  end

  test "get_transaction/2" do
    txid = "0x9e9526615ee7d460ed445c873c4af91bf7bfcc67e6e43feaf051b962a6df0a98"

    assert {
             :ok,
             %{
               asset: nil,
               block_hash:
                 <<213, 0, 206, 91, 206, 23, 53, 30, 158, 90, 36, 131, 52, 153, 207, 128, 242,
                   217, 136, 130, 121, 60, 19, 183, 187, 242, 33, 255, 50, 164, 44, 205>>,
               block_time: DateTime.from_unix!(1_476_647_836),
               hash:
                 <<158, 149, 38, 97, 94, 231, 212, 96, 237, 68, 92, 135, 60, 74, 249, 27, 247,
                   191, 204, 103, 230, 228, 63, 234, 240, 81, 185, 98, 166, 223, 10, 152>>,
               net_fee: Decimal.new(0),
               nonce: 3_576_443_283,
               extra: %{attributes: [], contract: nil, script: nil, scripts: []},
               size: 10,
               sys_fee: Decimal.new(0),
               type: :miner_transaction,
               version: 0,
               vins: [],
               vouts: [],
               claims: []
             }
           } == NeoNode.get_transaction(@fake_node_url, txid)

    assert {:ok, %{extra: %{scripts: [%{}], contract: %{}}}} =
             NeoNode.get_transaction(
               @fake_node_url,
               "fd161ccd87deab812daa433cbc0f8f6468de24f1d708187beef5ab9ada7050f3"
             )

    assert {:ok, %{extra: %{scripts: [%{}, %{}], script: "2102486fd15702c4490a2670" <> _}}} =
             NeoNode.get_transaction(
               @fake_node_url,
               "45ced268026de0fcaf7035e4960e860b98fe1ae5122e716d9daac1163f13e534"
             )

    assert {:error, %{"code" => -100, "message" => _message}} =
             NeoNode.get_transaction(
               @fake_node_url,
               "0000000000000000000000000000000000000000000000000000000000000000"
             )
  end

  test "get_asset/2" do
    txid = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"

    assert {
             :ok,
             %{
               admin:
                 <<23, 218, 23, 69, 233, 181, 73, 189, 11, 250, 26, 86, 153, 113, 199, 126, 186,
                   48, 205, 90, 75, 177, 213, 88, 117>>,
               amount: Decimal.new(100_000_000),
               available: Decimal.new(100_000_000),
               expiration: 4_000_000,
               frozen: false,
               issuer:
                 <<23, 218, 23, 69, 233, 181, 73, 189, 11, 250, 26, 86, 153, 113, 199, 126, 186,
                   48, 205, 90, 75, 177, 213, 88, 117>>,
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
           } == NeoNode.get_asset(@fake_node_url, txid)

    assert {:error, %{"code" => -100, "message" => _message}} =
             NeoNode.get_asset(
               @fake_node_url,
               "0x0000000000000000000000000000000000000000000000000000000000000000"
             )
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
           } = NeoNode.get_contract(@fake_node_url, contract_hash)

    assert {:error, %{"code" => -100, "message" => _message}} =
             NeoNode.get_contract(@fake_node_url, "0x0000000000000000000000000000000000000000")
  end
end
