defmodule Neoscan.BlocksTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  alias Neoscan.Blocks

  @block0 %{
    "confirmations" => 2_291_280,
    "hash" => "0xd42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf",
    "index" => 0,
    "merkleroot" => "0x803ff4abe3ea6533bcc0be574efa02f83ae8fdc651c879056b0d9be336c01bf4",
    "nextblockhash" => "0xd782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "000000007c2bac1d",
    "previousblockhash" => "0x0000000000000000000000000000000000000000000000000000000000000000",
    "script" => %{
      "invocation" => "",
      "verification" => "51"
    },
    "size" => 401,
    "time" => 1_468_595_301,
    "transfers" => [],
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 2_083_236_893,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0xfb5bd72b2d6792d75dc2f1084ffa9e9f70ca85543c717a6b13d9959b452a57d6",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      },
      %{
        "asset" => %{
          "admin" => "Abf2qMs1pzQb8kYk9RuxtUb9jtRKJVuBJt",
          "amount" => "100000000",
          "name" => [
            %{"lang" => "zh-CN", "name" => "小蚁股"},
            %{"lang" => "en", "name" => "AntShare"}
          ],
          "owner" => "00",
          "precision" => 0,
          "type" => "GoverningToken"
        },
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [],
        "size" => 107,
        "sys_fee" => "0",
        "txid" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
        "type" => "RegisterTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      },
      %{
        "asset" => %{
          "admin" => "AWKECj9RD8rS8RPcpCgYVjk1DeYyHwxZm3",
          "amount" => "100000000",
          "name" => [
            %{"lang" => "zh-CN", "name" => "小蚁币"},
            %{"lang" => "en", "name" => "AntCoin"}
          ],
          "owner" => "00",
          "precision" => 8,
          "type" => "UtilityToken"
        },
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [],
        "size" => 106,
        "sys_fee" => "0",
        "txid" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
        "type" => "RegisterTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [%{"invocation" => "", "verification" => "51"}],
        "size" => 69,
        "sys_fee" => "0",
        "txid" => "0x3631f66024ca6f5b033d7e0809eb993443374830025af904fb51b0334f127cda",
        "type" => "IssueTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AQVh2pG732YvtNaxEGkQUei3YA4cvo7d2i",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "100000000"
          }
        ]
      }
    ],
    "version" => 0
  }

  @block4130 %{
    "confirmations" => 2_287_186,
    "hash" => "0x6a7fe6471b3c2f92a393e7b49077bbac0ce131334393d75565be92b04d1bf1b4",
    "index" => 4130,
    "merkleroot" => "0x0e523d0390d2ebc1d84c9640459ff065232aadb7c485a068882105d8e1c936fa",
    "nextblockhash" => "0xdebe7fe75d977a89dfaf36f0f543e9e99add4e8f5ed5fcfa57afff9dca327400",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "1652c5384c5afe53",
    "previousblockhash" => "0xeeb694b93c56d60528c55549ce2216077584e8976eb8f77519dcdfa9643ab4a8",
    "script" => %{
      "invocation" =>
        "40353e08bf28525702ae3f09b58504eb05e1a435bb44fd4adb3773a3bb0d36e4aa74ef8b81bae60cfbb5726ecd106b4e89fd110f312528719c74b7d50c70f0531d4062f0a12518b36c38efe9f97b5a7d0ba02865db4de8d8c137e9bd067fd19fe5bc2af4eae347e6d679e4603eb2cc6e5a7b0e9301961f6b4f902973c1889f7e531840b4a27d5ae0abb10bc9fdad4f46ddb4d598b2a65d80289fafc64f5a3022a511db6187df1d499812fd55ca8fffbcb90b7d7ec7a09dc3ad89e0d2f96c36e002a64c40bf59b482f88072848bb5f1d680742514dc6a729c330133771acf21e323ce6ee379d85372ae2d3d0ea98487f2352bad4f7066995db137b765d2c8a342182ec1b140e9386cc1ed8f400f2b0494832dc0d434389c3bc6bbc730d1567262b86556e336c5aeccc2c7c4e4cb8d12b1c8b0b801d472d8276e990a83db75716167be5a7004",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 1351,
    "time" => 1_476_724_549,
    "transfers" => [],
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 1_281_031_763,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0x5f5e4058ea59a8f53f38186061661e7be01b4952d1393784f7ff9bd8ef87d793",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "406a159b7552c7eaedc79abc86faeca7aa50af52aaa0f14aa9a4abaf498f270a140709992253df55de1b2fd93a6ea13b5344dacbd4e54e4f661fe073edeb72e2f740e28c0866c2ea963e40f8f6edbc1e40b76181fef43a4016d234602a52b31b83f02d745d57188cd72fcb1a8394a39d77270334374848266bb87a29fa4114d1b13240c1e7eae0e8e8d33b1a16c8ece8e96bc832d8f0a069499b8b9590609d8cd2a799a555f5433bdc153466bf6eefea0a568bd08b28afabfacb673785fe8d59ab82ea404874390b85c4d37d3645e03cae571000f3ca344452c2a4018aab57f73750dfb695c5488e3c9887699a2ff69e539b7e37278f470b03bc357ebaad25c397ef3104",
            "verification" =>
              "542102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
          }
        ],
        "size" => 665,
        "sys_fee" => "0",
        "txid" => "0xee85d489e4428a538f39c1903771e1f222a383f8327c96ed19cc02079149a1fd",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x3631f66024ca6f5b033d7e0809eb993443374830025af904fb51b0334f127cda",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "Ae2d6qj91YL3LVUMkza7WQsaTYjzjHm4z1",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "1000"
          },
          %{
            "address" => "AWHX6wX5mEJ4Vwg7uBcqESeq3NggtNFhzD",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "99999000"
          }
        ]
      }
    ],
    "version" => 0
  }

  describe "blocks" do
    alias Neoscan.Blocks.Block

    test "home_blocks/0" do
      block = insert(:block)
      [block1] = Blocks.home_blocks()
      assert block.hash == block1.hash
    end

    test "paginate_blocks/1" do
      for _ <- 1..20, do: insert(:block)
      assert 15 == Enum.count(Blocks.paginate_blocks(1))
      assert 5 == Enum.count(Blocks.paginate_blocks(2))
      assert 0 == Enum.count(Blocks.paginate_blocks(3))
    end

    test "list_blocks/0 returns all blocks" do
      block = insert(:block)
      assert Blocks.list_blocks() == [block]
    end

    test "get_block!/1 returns the block with given id" do
      block = insert(:block)
      assert Blocks.get_block!(block.id) == block
    end

    test "get_block_by_hash/1" do
      block = insert(:block)
      assert block.id == Blocks.get_block_by_hash(block.hash).id
    end

    test "get_block_by_hash_for_view/1" do
      block = insert(:block)
      assert block.id == Blocks.get_block_by_hash_for_view(block.hash).id
    end

    test "paginate_transactions/2" do
      block = insert(:block)
      insert(:transaction, %{block_id: block.id})
      {_, transactions} = Blocks.paginate_transactions(block.hash, 1)
      assert 1 == Enum.count(transactions)
    end

    test "get_block_by_height/1" do
      block = insert(:block)
      assert block.id == Blocks.get_block_by_height(block.index).id
      assert is_nil(Blocks.get_block_by_height(12355))
    end

    test "get_block_time/1" do
      assert 1_476_649_675 == Blocks.get_block_time(123)
    end

    test "create_block/1 with valid data creates a block" do
      block = insert(:block)
      assert block.confirmations == 50
      assert String.contains?(block.hash, "hash")
      assert String.length(block.merkleroot) > 64
      assert String.length(block.nextblockhash) > 64
      assert String.length(block.nextconsensus) > 64
      assert String.contains?(block.nonce, "nonce")
      assert String.length(block.previousblockhash) > 64
      assert %{} = block.script
      assert block.size == 1526
      assert block.time == 15_154_813
      assert block.version == 2
    end

    test "get_higher_than/1" do
      block1 = insert(:block)
      %{id: block_id} = insert(:block)
      assert [%{id: ^block_id}] = Blocks.get_higher_than(block1.index)
    end

    test "delete_higher_than/1" do
      block1 = insert(:block)
      %{id: block_id} = insert(:block)
      assert [] == Blocks.delete_higher_than(block_id)
      assert [%{id: ^block_id}] = Blocks.get_higher_than(block1.index)

      assert block_id ==
               block1.index
               |> Blocks.delete_higher_than()
               |> List.first()
               |> Map.get(:id)

      assert [] = Blocks.get_higher_than(block1.index)
    end

    test "update_block/2 with valid data updates the block" do
      block = insert(:block)

      assert {:ok, block} =
               Blocks.update_block(block, %{
                 "confirmations" => 57,
                 "hash" => "b33f6f3dfead7dddpo99846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "merkleroot" =>
                   "b33f6f3dfead7ddpe999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "nextblockhash" =>
                   "b33f6f3dfead7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "previousblockhash" =>
                   "b33f6f3dfpad7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8",
                 "index" => 1
               })

      assert block.confirmations == 57
    end

    test "update_block/2 with invalid data returns error changeset" do
      block = insert(:block)
      assert {:error, %Ecto.Changeset{}} = Blocks.update_block(block, %{"confirmations" => nil})
      assert block == Blocks.get_block!(block.id)
    end

    test "delete_block/1 deletes the block" do
      block = insert(:block)
      assert %Block{} = Blocks.delete_block(block)
      assert_raise Ecto.NoResultsError, fn -> Blocks.get_block!(block.id) end
    end

    test "add_block/1" do
      assert :ok == Blocks.add_block(@block0)
      assert :ok == Blocks.add_block(@block4130)
    end

    test "compute_fees/1" do
      block = %{
        "tx" => [
          %{"sys_fee" => "123.4", "net_fee" => "error"},
          %{"sys_fee" => "error", "net_fee" => "567.8"}
        ]
      }

      assert %{"total_sys_fee" => 123.4, "total_net_fee" => 567.8, "tx" => block["tx"]} ==
               Blocks.compute_fees(block)
    end
  end
end
