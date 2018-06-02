defmodule NeoscanNode.HttpCalls.HTTPPoisonWrapper do
  @moduledoc false

  @block0 %{
    "confirmations" => 2_326_310,
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
    ]
  }

  @block1 %{
    "confirmations" => 2_326_309,
    "hash" => "0xd782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9",
    "index" => 1,
    "merkleroot" => "0xd6ba8b0f381897a59396394e9ce266a3d1d0857b5e3827941c2d2cedc38ef918",
    "nextblockhash" => "0xbf638e92c85016df9bc3b62b33f3879fa22d49d5f55d822b423149a3bca9e574",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "6c727071bbd09044",
    "previousblockhash" => "0xd42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf",
    "script" => %{
      "invocation" =>
        "404edf5005771de04619235d5a4c7a9a11bb78e008541f1da7725f654c33380a3c87e2959a025da706d7255cb3a3fa07ebe9c6559d0d9e6213c68049168eb1056f4038a338f879930c8adc168983f60aae6f8542365d844f004976346b70fb0dd31aa1dbd4abd81e4a4aeef9941ecd4e2dd2c1a5b05e1cc74454d0403edaee6d7a4d4099d33c0b889bf6f3e6d87ab1b11140282e9a3265b0b9b918d6020b2c62d5a040c7e0c2c7c1dae3af9b19b178c71552ebd0b596e401c175067c70ea75717c8c00404e0ebd369e81093866fe29406dbf6b402c003774541799d08bf9bb0fc6070ec0f6bad908ab95f05fa64e682b485800b3c12102a8596e6c715ec76f4564d5eff34070e0521979fcd2cbbfa1456d97cc18d9b4a6ad87a97a2a0bcdedbf71b6c9676c645886056821b6f3fec8694894c66f41b762bc4e29e46ad15aee47f05d27d822",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 686,
    "time" => 1_476_647_382,
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 3_151_007_812,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0xd6ba8b0f381897a59396394e9ce266a3d1d0857b5e3827941c2d2cedc38ef918",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      }
    ]
  }

  @block2 %{
    "confirmations" => 2_326_504,
    "hash" => "0xbf638e92c85016df9bc3b62b33f3879fa22d49d5f55d822b423149a3bca9e574",
    "index" => 2,
    "merkleroot" => "0xafa183a1579babc4d55f5609c68710954c27132d146427fb426af54295df0842",
    "nextblockhash" => "0x1fca8800f1ffbc9fb08bcfee1269461161d58dcee0252cf4db13220ba8189c5d",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "b29a9ce838a86fb6",
    "previousblockhash" => "0xd782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9",
    "script" => %{
      "invocation" =>
        "40e8a85159d8655c7b5a66429831eb15dabefc0f27a22bef67febb9eccb6859cc4c5c6ae675175a0bbefeeeeff2a8e9f175aaaae0796f3b5f29cb93b5b50fbf270409270a02cbbcb99969d6dc8a85708d5609dc1bba9569c849b53db7896c7f1ffd3adc789c0fe8400fb665478567448b4c4bd9c1657432591e4de83df10348f865a40724a9cf9d43eda558bfa8755e7bd1c0e9282f96164f4ff0b7369fd80e878cf49f2e61ed0fdf8cf218e7fdd471be5f29ef1242c39f3695d5decb169667fe0d3d140860da333249f7c54db09b548ad5d5e45fb8787238d51b35a6d4759f7990f47f00ff102e7b88f45acce423dd9f4b87dbf85e7e2c5c7a6aace11e62267c0bbe16b4028d272a701c22c5f8aa3495fa22d7d5a583518ef552e73813ee369c6d51ad2f246a24eb0092ebe7e1550d7de2ee09abad4dae4f4c0277317f5b1190041b9c2c2",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 686,
    "time" => 1_476_647_402,
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 950_562_742,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0xafa183a1579babc4d55f5609c68710954c27132d146427fb426af54295df0842",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      }
    ],
    "version" => 0
  }

  @block123 %{
    "confirmations" => 2_326_366,
    "hash" => "0x87ba13e7af11d599364f7ee0e59970e7e84611bbdbe27e4fccee8fb7ec6aba28",
    "index" => 123,
    "merkleroot" => "0xd55b5eade05a6a5b2021fe065107ac652ffc960c063bb13255f58ac9fe136dd7",
    "nextblockhash" => "0x6cc7b645d5be908967f9477dfb8e47ad0a84b7486442548ab4439ea3dc480f1f",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "5945c1e2ed85a0fd",
    "previousblockhash" => "0x9d704ae187dc34c348ff4daa65a1a1383ed5f6f6f4eb68fc24b9a874b4442da6",
    "script" => %{
      "invocation" =>
        "40d47a033f32de40908f58c84e9acd89b03e7943f91056ac80adc64892ffa200dd75d0ffb340a12963a80e5432e12a70cd9317e5d29cab1966d0a70ae2a6968b544085858865fe8773eecf2eb64aeabeb952aadd9fee5c5fa2e208cba2cd79220604deb3d318f0a9f9aeed75f85a97d527ef8ad3d87c019ac74361f926b9b067827c4070188e617e5608e16597edffee6b964b80b99803f10fd58b16e4d376e2e447810d6d02749a926cd2fb880158ca11e7ee2b91b7adc5d46e4500678b4131f7e32740693cf2227da04612f6d706994a21b29d33769b10f2a37807643145b9609bae33ac5b700118fd26661a2f1b01149ca3f1984c7e2c3f61c2da23b2ae966c66898640e6bae967949195b17dea3cf145c0502a060ee88a09d0f4b91b2e3d7ff3d211bbbdedab4c485d9f9149ef7d1eabae4adaf32a45c8d81d7bf4762bfb4afa51cb25",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 686,
    "time" => 1_476_649_675,
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 3_984_957_693,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0xd55b5eade05a6a5b2021fe065107ac652ffc960c063bb13255f58ac9fe136dd7",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => []
      }
    ],
    "version" => 0
  }

  @block199 %{
    "id" => 5,
    "jsonrpc" => "2.0",
    "result" => %{
      "confirmations" => 2_326_284,
      "hash" => "0xb4cabbcde5e5d5ecf0429cb4726f7a4d857e195e12bdc568cb1df2097c2d918d",
      "index" => 199,
      "merkleroot" => "0x22785537b678da290b0fa00cf1703a0436f303ee1c8a8e8f5e93615fcbb6a280",
      "nextblockhash" => "0xe5313431ecd1b59d1cb7848f35dadc5e51ebd700fd232fe3502003e14aeb9bf7",
      "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
      "nonce" => "d76e2a45089c0672",
      "previousblockhash" => "0x5fc3475ffa875d6e82d63523ba7a83e218e81d03a20ce36fd792d0cfbdbeb68c",
      "script" => %{
        "invocation" =>
          "404d679bb8131a0fe995bf0f4c4122be78ac085bfbbaf0d71e729ce832e4761e0c245fc53c23dad1d3d5fdd0f1a558de107d0f882ecb6a349ffe02e33dbe83f21e40617e3686538763de96941da201aff56c7de25d321323ed0b6fb076ab2652f8ee3b230066eec67483c37cfef315608d7c30f68929c0fc718c86e5ec20ffef901c407f3970ddb448e1d24e40afbfc5b75b69967a36da8a98ab2aa9cfe62bf465dcb16c1902d07c15e7c2c02d68583d051376f95f353252620b6cad5338d27546870240ff95af7bbd16249f17480a72ea6a6d45cab4948cc68d72f8d51930af8c512c4308a69da5a72136ec7193f142871225a3c1aafeac44cb306a275c32715a0dc969400a66a4d9e6f2ae56157246a72b0b044e54532c8d70ca2f65e4991c376b880a44e6b3e9be3e86ee577238f28802c3f28889c19d48bc1845098e061f8794af8225",
        "verification" =>
          "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
      },
      "size" => 686,
      "time" => 1_476_651_110,
      "tx" => [
        %{
          "attributes" => [],
          "net_fee" => "0",
          "nonce" => 144_442_994,
          "scripts" => [],
          "size" => 10,
          "sys_fee" => "0",
          "txid" => "0x22785537b678da290b0fa00cf1703a0436f303ee1c8a8e8f5e93615fcbb6a280",
          "type" => "MinerTransaction",
          "version" => 0,
          "vin" => [],
          "vout" => []
        }
      ],
      "version" => 0
    }
  }

  @block2120069 %{
    "confirmations" => 217_636,
    "hash" => "0x61042bfbc39b410c61484a1fc6fdd46a8c1addcce57a65103b0e7e15ed0f38e2",
    "index" => 2_120_069,
    "merkleroot" => "0xe6f014431d6f0a3434fb6bdbb2d9d7043c0526011b3a09a7d95d8c0cfe762eba",
    "nextblockhash" => "0xdca882cbada3b37d2b46523154aee8e24bcf2823fb279386473c1329cbb24d9e",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "45ddb5022b328139",
    "previousblockhash" => "0x0db722438a781930f371e9f3cf3640dd5f18ada360b81c62dc53a73f4796714a",
    "script" => %{
      "invocation" =>
        "4002b683bc3c58bbaeeb7cf57f31bdb6310e97945a2e97f9b5456e1969f76944cead0d822af7364eeb1d8b9b78ce5e1814264e2af27cf7ec213a741f3ebd1dd061406606d539f1e8af7c2ef51d16f7e140278fd8bef7845f0d8ec6abd4fcefd18f10916308ce858b8003bf939d2389226d432cf4a2191903a748b4e2f0efb329bf68405406ef62adc993af39cc990e13dc8742f34c0aca384bc1fa63a2f3fd870f9dcd3f1d33dc36b69d00cc4cbe5f070eb7a7d7197fc96874d0f1bd2571ede308f81a405360639cb6da93b22a72b75fa754650651f3739ab4378794ecf8b10169ff7ac473f93051a5c8dba9fc95e68b8634bc77d79a34615a8be97b4520df264c28ae5740f31466eb0a3ff03e1fe774183297d9d945c90beb5364f5fb44e153c7554db537fde270ac9da6698a6d4a59c561a3d6bf212563c1d071531af3604eecfa597520",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 7332,
    "time" => 1_523_181_098,
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 724_730_169,
        "scripts" => [],
        "size" => 10,
        "sys_fee" => "0",
        "txid" => "0xac7ac88ad7b19538d0b7f8560abda1be344098cf6d9d6266b1c028160f8e7be6",
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
              "40e54c344b3011bbcea9c96b3aa2160ff9fc51255f1ce35bf04b26ca89f5f09068f7d8486abf11ce2c001ef942f373104e5e6eafb08cd5da50ea4677cb7f4553de",
            "verification" =>
              "2103831a2118274db3627775a52c1ecfd73904fb3f8ed916654bdfb093b4e5b98800ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xf3f185e62b02aaf6148a7614b943b1c640e08effc32be45a02fa548cb80e3c63",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x78217fe5d27b3392c7111afa4d615d70d84cd3179374dc1875f9ecb2774f56d5",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "Ab9VnEtwvJiJs9EzzWA9kJH8rm2UvoAjQ2",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "315"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "408f733f6219423e9104434e207738ec2152db8c97153008d8b70c0327e195e59a573809173b49f6bdb544d978b403c20ba7c7d9ea12e7e4622ceb0236e2520178",
            "verification" =>
              "2102ba338b892051e7946a01db5e6070241d9ebd9e47028033aa492c10837092f164ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xea2df2113958621090f949a5785b353d7e821b56b5d9ebe62ba8db5f167e8225",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x0f4e826f30b927b9bba4f14a06cf16c1d23f3ba4b27969e67186d03f12ee1f1d",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AbZhKaVk59Jxuwzkk9XrRxFwzLhwzhTHeA",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "100"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40a7537342d5c8719be9a2cfe9da155afd8930bb71413d51aa07cdb1231d3ce4b65fea96499059c22a0a143b5c5737e5ee3a562d5e2c4fb74b7111aa83fb409807",
            "verification" =>
              "210269a1fe5d5c5de9f268ae44885518c9a5f087ea001777ea6e2ff18a45408d2b8eac"
          },
          %{
            "invocation" =>
              "407dd618cbda1a8a7a5844e377a51838d2f37407a07288e869a51792961dda61d35f696d5a66b609f80870edc962e7b4d48541ed75e30e38942710a2cdb13251e6",
            "verification" =>
              "210320bba1040f8983ee6caa1326e7509449f8569400046e7903e39b3218ed1db4baac"
          },
          %{
            "invocation" =>
              "404c6b21ceb1a8295f2d6394aa61a5d60fe9d52b1034210e1b2af9bedff90257218391fa6cc75edb89d37cc679d91920ba741e804d0ae94643f3b17d4903555c91",
            "verification" =>
              "21027c0a815027b73b371347c38b391a0f0f1815a79680185854e771346e76ac902fac"
          }
        ],
        "size" => 654,
        "sys_fee" => "0",
        "txid" => "0xab6fb0e8a02a6ed8c075cfeac9da3cd7f440da5bf7cd4c8579478b8a1ee419ee",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x02b497ea1dc8aa9349d2c8bbaa79dbcc40aa77b398fe1bec8012d96dcb7d1c86",
            "vout" => 2
          },
          %{
            "txid" => "0x46ba72b7e8f0a71ae6644bf47262624215fb98581498f9b5b3d6d5f94c0fc8ac",
            "vout" => 3
          },
          %{
            "txid" => "0x5db33685bcf163bb100bb4c493765949d8756ec38cb780fb9a116df01f556c5f",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AZHJD3yq2oC4m19ziV6woq8N7n6WAJCjWS",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "20"
          },
          %{
            "address" => "AT4TTRxrPFuxLGmkydYrt8a1GiFewGqZGA",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "733"
          },
          %{
            "address" => "AeQLu1AXvXxNnamiX1RvU6pZ1GGhWPKDAq",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 2,
            "value" => "7"
          },
          %{
            "address" => "AKxVv9ti4na6SJdPg9SWttJLE1Web869fS",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 3,
            "value" => "48"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xff6341a02ede751ef587ba20fff994b51c24ac0570ca70f823022808aa7c3bbf",
            "vout" => 0
          },
          %{
            "txid" => "0x66f0d21a33705b80d4250baf29d7a24a566f4b54b1c4140dac1f93ec26901f2a",
            "vout" => 0
          },
          %{
            "txid" => "0x94d227562bc11d010e58e323c12a5e8bc056bb9288fc2f89bfe2bc5a3fef86fd",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4023c75edfe823d76905ee1e4c15c9b7f2501fe79b27e6f12919ffc06413fa7f7ceb263f05ad4fe87cbf47d986dc52481e982cec3a7603c981e1ab9f7a94c6a671",
            "verification" =>
              "21039a80bb96e6c0cdd60d91143b8132232d84430d1710aa916902212b9a55b08ceeac"
          }
        ],
        "size" => 271,
        "sys_fee" => "0",
        "txid" => "0x855610bcd7b69fdeef65f8b73a066999f87124d96000e3c28c90b59634ab7c78",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AZ4ZaDg6H9L9JjVbHd7kNW7t2rLbejyaAb",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0011858"
          }
        ]
      },
      %{
        "attributes" => [],
        "gas" => "0",
        "net_fee" => "0",
        "script" =>
          "208663c57d6f829667c61cf395315119ed1155448b803071df64a40032662f8571348558ca14c02f47b85f4a2404f4a53ff7a693d4459b7cffdaa674beae0f930ebe6085af9093e5fe56b34a5c220ccdcf6efc336fc552c10b63616e63656c4f66666572671f559d5eea8ca22910a3feb0e4637c0f2e71c50e",
        "scripts" => [
          %{
            "invocation" =>
              "4079d856792e7ec01dc0ce066cefbfad37e1098483c875a0cc7efee7aad6f9687c5e4361599ca7e60a28bad4a134ec7f721d843f218ef845dbdf04708dc11647a9",
            "verification" =>
              "21038f3c43e504e2185a93dd5372176e0fd08271547edb34ec88f24ff78eec41ba83ac"
          }
        ],
        "size" => 324,
        "sys_fee" => "0",
        "txid" => "0x81bac3c2ecb0c8d331a621c5578b419856bfc3e5a9dcfd3e72ecf447eb0bfe06",
        "type" => "InvocationTransaction",
        "version" => 1,
        "vin" => [
          %{
            "txid" => "0xc89b71b9a7fc5f25f12550690d1f3bcf581ba1cb65681fd83ab2e8f5aa7bdd85",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AKaTLdd4Hb3bGQSCPvqnWoe8b7igPZmAFN",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.00000001"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xa4d5fa1a10518f23c093c4859a0750bc40677845e5d40af05ac3d8c39af512d0",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40edaa253c6ef4c1af1c79c4afe5a23371f5a5cc0c95a81fef968699006e2c069e6910f3118de3ec4f122d5ecbf21745e4d40f410ecc4b89d08302e5c4ce0f3b42",
            "verification" =>
              "21034f1b557274edd91a8e8ebf6e66c5151dbba5cb842b2f02325e1f7ee630a0380fac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xc8add97a251f10fd77147668bafa37e68316554cd9d64503db9f8d60f52408d1",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AaWpzUxaseVH3aUvtp5dD4QbsSTg6CvkNB",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.21264285"
          }
        ]
      },
      %{
        "attributes" => [
          %{
            "data" => "bf28093023643bb0858a119f0e065b450b14564c",
            "usage" => "Script"
          }
        ],
        "gas" => "0",
        "net_fee" => "0",
        "script" =>
          "0600bf7c481809145534bd37e4d65543700f00cdb833b1da94e4927314bf28093023643bb0858a119f0e065b450b14564c53c1087472616e7366657267187fc13bec8ff0906c079e7f4cc8276709472913f1660524be56b66d3cc9",
        "scripts" => [
          %{
            "invocation" =>
              "4005bbd111005e52f7021d5ce3a65ae6eb804b0361a3d97c8463ffac8e2bf18e46ce42dd9584aab08c6f8d378328dc77a5bd03d7edec92bd4a5704b708382408a0",
            "verification" =>
              "21035bdb8f130dfbb25037f93a26afdb0ea04973d893711351ed9afca51e3f4a17daac"
          }
        ],
        "size" => 221,
        "sys_fee" => "0",
        "txid" => "0xd3da8bac63bbc06a32e72b34ad755f17b7ff19d0cd436a57d6999eed398ec8b3",
        "type" => "InvocationTransaction",
        "version" => 1,
        "vin" => [],
        "vout" => []
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xb71a32964d02d9d9c105f5c1bb98c24665a61aaf75b08edb066ece210367a298",
            "vout" => 0
          },
          %{
            "txid" => "0xae6ca84df552d038f6bf557e8fa1af45686f7332950bbabd40b15147ed2097ac",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40c4a04edb81b4aea285390d8a5b46c77b4db24d11a981c176578130ce7d491477be407265e3437cd8edfdf3968b647dffd7da83ab9aa5bd8f642e6117bbf06df6",
            "verification" =>
              "21035f692136e46dcab4455e8f015f8ce04e0473f6b41bf84015ed8a5afbcc9f9136ac"
          }
        ],
        "size" => 237,
        "sys_fee" => "0",
        "txid" => "0x6b79145ac24fac0bddc4df98d22b136e514a05e6d1578c8ae721948ed23b6326",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AKVwoXxikfMQtLC6tezQcdszrLJgDMUsLq",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.01193004"
          }
        ]
      },
      %{
        "attributes" => [%{"data" => "6e656f2d6f6e65", "usage" => "Remark15"}],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "407e4305984ec8b7563c9815976e1e5c40347adeb71e3a9fe772253f35cdff42825afac3e39dc88ee7e7728c1f56d2941e998cb95608f946d3a22f4ac1fb0b9034",
            "verification" =>
              "21021cdb84434d21cd0500d0a2e6f3305e78791cf33b56627f2a43a129a29d9d6920ac"
          }
        ],
        "size" => 211,
        "sys_fee" => "0",
        "txid" => "0x2592139d2521d9ff1d9c602f538be0229cfec04854c383bc21a606ee9469853a",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x8c8c94c62ef52e355d5f26ca5c6ea6943923580490a4ce0067bf65c1419de98d",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AMDfGmyBh6RCuZ4PCAoDuPVNjgDAhGK91a",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "10"
          }
        ]
      },
      %{
        "attributes" => [],
        "gas" => "490",
        "net_fee" => "0",
        "script" => "084c726e546f6b656e0140084c6f6f7072696e67013108",
        "scripts" => [
          %{
            "invocation" =>
              "40277f87254fcb33a76487f0527134d5b4eaae1baa834d12757c8002804f687df04d14c9865f321bde8356a1c9e5ba709546c21cd5ca52b9727594845ca0dd9e8f",
            "verification" =>
              "2103730df1d0f8bf2e2df4d1502f30e507ee09dc0c56f0a11c5a23bf0a68eba2b556ac"
          }
        ],
        "size" => 3909,
        "sys_fee" => "490",
        "txid" => "0xe708a3e7697d89b9d3775399dcee22ffffed9602c4077968a66e059a4cccbe25",
        "type" => "InvocationTransaction",
        "version" => 1,
        "vin" => [
          %{
            "txid" => "0x57d6aa151fcf99dd29a5b651bc2295be77b8ed588dd13f2a43436a9e040acac2",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AZy6n4jDAN4ssEDucN42Cpyj442K4u16r4",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "510"
          }
        ]
      },
      %{
        "attributes" => [%{"data" => "6e656f2d6f6e65", "usage" => "Remark15"}],
        "claims" => [
          %{
            "txid" => "0x2962439d9ecff6b38d8169ab8858d1983663ad308d99681d47d94f77de56e05b",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4079c5e8cc89f86080363fc1a29bb2c5ea9784b84ef1c56a48af0918c3f7fb147eebdd7a1462027ec3465d16649ce240a4cb8a828bbce01b09829a03bfe90c827a",
            "verification" =>
              "210350feb6bcbcb342befda2bfde15ebdc0d35ac576624ca060fa129f2e8accd1109ac"
          }
        ],
        "size" => 212,
        "sys_fee" => "0",
        "txid" => "0x762435e41c83ddf01807891aad58a6f1a1bb1a9e51a8ead3885fbd5251028a2b",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ASGYHG2org22KsnXwD7YeayaEE1NHKubJk",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.00000182"
          }
        ]
      }
    ],
    "version" => 0
  }

  @transaction %{
    "txid" => "0x9e9526615ee7d460ed445c873c4af91bf7bfcc67e6e43feaf051b962a6df0a98",
    "size" => 10,
    "type" => "MinerTransaction",
    "version" => 0,
    "attributes" => [],
    "vin" => [],
    "vout" => [],
    "sys_fee" => "0",
    "net_fee" => "0",
    "scripts" => [],
    "nonce" => 3_576_443_283,
    "blockhash" => "0xd500ce5bce17351e9e5a24833499cf80f2d98882793c13b7bbf221ff32a42ccd",
    "confirmations" => 2_326_325,
    "blocktime" => 1_476_647_836
  }

  @transaction9f %{
    "attributes" => [
      %{
        "data" =>
          "6e656f2d6f6e652d696e766f6b653a7b22636f6e7472616374223a22307861383763633261353133663564386234613432343332333433363837633231323763363062633366222c226d6574686f64223a227472616e73666572222c22706172616d73223a5b5b2266726f6d222c22307861636134666635653565663234346631383865643563636634393238316635336463383666383635225d2c5b22746f222c22307835343438373039393339313434303564393763396565343931393534646530623235613466323666225d2c5b2276616c7565222c22302e303031225d5d7d",
        "usage" => "Remark14"
      },
      %{"data" => "6e656f2d6f6e65", "usage" => "Remark15"},
      %{"data" => "34313834353436363237", "usage" => "Remark15"},
      %{
        "data" => "65f886dc531f2849cf5ced88f144f25e5effa4ac",
        "usage" => "Script"
      }
    ],
    "blockhash" => "0x1670427ca839ab855a32694a803dc1357840ecb1a5ffc2ac3731b0e129b3b956",
    "blocktime" => 1_527_582_147,
    "confirmations" => 387,
    "gas" => "0",
    "net_fee" => "0",
    "script" =>
      "03a08601146ff2a4250bde541949eec9975d401439997048541465f886dc531f2849cf5ced88f144f25e5effa4ac53c1087472616e73666572673fbc607c12c28736343224a4b4d8f513a5c27ca8",
    "scripts" => [
      %{
        "invocation" =>
          "40638f88bc555bc114c7f835735e2ba558a7b8d79ad6ac002eda4314cbbbeb50a2e8dde4ecedd7bf31a11333e0d3be947ae43f18406bc46b9fb3ebf7181cfbbfd2",
        "verification" => "210381db9ec3fe4bea3da50ad739ef56b7c3dceebfb0331bbe9da862dadbc0c231b8ac"
      }
    ],
    "size" => 458,
    "sys_fee" => "0",
    "txid" => "0x9f3316d2eaa4c5cdd8cfbd3252be14efb8e9dcd76d3115517c45f85946db41b2",
    "type" => "InvocationTransaction",
    "version" => 1,
    "vin" => [],
    "vout" => []
  }

  @asset %{
    "version" => 0,
    "id" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
    "type" => "GoverningToken",
    "name" => [
      %{"lang" => "zh-CN", "name" => "\\u5C0F\\u8681\\u80A1"},
      %{"lang" => "en", "name" => "AntShare"}
    ],
    "amount" => "100000000",
    "available" => "100000000",
    "precision" => 0,
    "owner" => "00",
    "admin" => "Abf2qMs1pzQb8kYk9RuxtUb9jtRKJVuBJt",
    "issuer" => "Abf2qMs1pzQb8kYk9RuxtUb9jtRKJVuBJt",
    "expiration" => 4_000_000,
    "frozen" => false
  }

  @contract %{
    "author" => "Red Pulse",
    "code_version" => "1.0",
    "description" => "RPX Sale",
    "email" => "rpx@red-pulse.com",
    "hash" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
    "name" => "RPX Sale",
    "parameters" => ["String", "Array"],
    "properties" => %{
      "dynamic_invoke" => false,
      "storage" => true
    },
    "returntype" => "ByteArray",
    "script" => "011f",
    "version" => 0
  }

  @tokens %{
    "current_height" => 2_326_419,
    "message" => "",
    "page" => 0,
    "page_len" => 500,
    "results" => [
      %{
        "block" => 2_120_069,
        "contract" => %{
          "author" => "Loopring",
          "code" => %{
            "hash" => "0xcb9f3b7c6fb1cf2c13a40637c189bdd066a272b4",
            "parameters" => "0710",
            "returntype" => 5,
            "script" => ""
          },
          "code_version" => "1",
          "description" => "LrnToken",
          "email" => "@",
          "name" => "lrnToken",
          "properties" => %{
            "dynamic_invoke" => false,
            "storage" => true
          },
          "version" => 0
        },
        "token" => %{
          "contract_address" => "AQV236N8gvwsPpNkMeVFK5T8gSTriU1gri",
          "decimals" => 8,
          "name" => "Loopring Neo Token",
          "script_hash" => "0x06fa8be9b6609d963e8fc63977b9f8dc5f10895f",
          "symbol" => "LRN"
        },
        "tx" => "0xe708a3e7697d89b9d3775399dcee22ffffed9602c4077968a66e059a4cccbe25",
        "type" => "SmartContract.Contract.Create"
      }
    ],
    "total" => 1
  }

  def post(url, data, headers, opts) do
    result = handle_post(Poison.decode!(data))

    if is_nil(result) do
      IO.inspect({url, data, headers, opts})
      result = HTTPoison.post(url, data, headers, opts)
      IO.inspect(result)
      IO.inspect(Poison.decode!(:zlib.gunzip(elem(result, 1).body)), limit: :infinity)
      result
    else
      result
    end
  end

  def handle_post(%{"method" => "getblockerror"}) do
    body =
      Poison.encode!(%{
        "error" => %{
          "code" => -32601,
          "message" => "Method not found"
        },
        "id" => 5,
        "jsonrpc" => "2.0"
      })

    {:ok, %HTTPoison.Response{headers: [], status_code: 200, body: body}}
  end

  def handle_post(%{
        "params" => [hash],
        "method" => "getcontractstate",
        "jsonrpc" => "2.0",
        "id" => 5
      }) do
    result = contract_data(hash)

    unless is_nil(result) do
      body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => result}))

      {:ok,
       %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}}
    end
  end

  def handle_post(%{
        "params" => [hash, _length],
        "method" => "getrawtransaction",
        "jsonrpc" => "2.0",
        "id" => 5
      }) do
    result = transaction_data(hash)

    unless is_nil(result) do
      body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => result}))

      {:ok,
       %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}}
    end
  end

  def handle_post(%{
        "params" => [hash, _length],
        "method" => "getblock",
        "jsonrpc" => "2.0",
        "id" => 5
      }) do
    result = block_data(hash)

    unless is_nil(result) do
      body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => result}))

      {:ok,
       %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}}
    end
  end

  def handle_post(%{
        "params" => [hash, _length],
        "method" => "getassetstate",
        "jsonrpc" => "2.0",
        "id" => 5
      }) do
    result = asset_data(hash)

    unless is_nil(result) do
      body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => result}))

      {:ok,
       %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}}
    end
  end

  def handle_post(%{"params" => [], "method" => "getblockcount", "jsonrpc" => "2.0", "id" => 5}) do
    body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => 200}))

    {:ok,
     %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}}
  end

  def handle_post(_), do: nil

  def block_data(0), do: @block0
  def block_data(1), do: @block1
  def block_data(2), do: @block2
  def block_data(123), do: @block123
  def block_data(199), do: @block199
  def block_data(2_120_069), do: @block2120069
  def block_data("d42561e3d30e15be6400b6df2f328e02d2bf6354c41dce433bc57687c82144bf"), do: @block0
  def block_data("d782db8a38b0eea0d7394e0f007c61c71798867578c77c387c08113903946cc9"), do: @block1

  def block_data("87ba13e7af11d599364f7ee0e59970e7e84611bbdbe27e4fccee8fb7ec6aba28"),
    do: @block123

  def block_data(_), do: nil

  def transaction_data("9f3316d2eaa4c5cdd8cfbd3252be14efb8e9dcd76d3115517c45f85946db41b2"),
    do: @transaction9f

  def transaction_data("0x9e9526615ee7d460ed445c873c4af91bf7bfcc67e6e43feaf051b962a6df0a98"),
    do: @transaction

  def transaction_data(_), do: nil

  def asset_data("c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"), do: @asset
  def asset_data("0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"), do: @asset
  def asset_data(_), do: nil

  def contract_data("0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"), do: @contract
  def contract_data(_), do: nil

  def get("http://notifications1.neeeo.org/v1/notifications/block/1444843", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_337_751,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [
              %{
                "addr_from" => "AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzM",
                "addr_to" => "ATuT3d1cM4gtg6HezpFrgMppAV3wC5Pjd9",
                "amount" => 5_065_200_000_000_000,
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzM",
                "addr_to" => "AHWaJejUjvez5R6SW5kbWrMoLA9vSzTpW9",
                "amount" => 9_096_780_000_000_000,
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "AFmseVrdL9f9oyCzZefL9tG6UbvhPbdYzM",
                "addr_to" => "AN8cLUwpv7UEWTVxXgGKeuWvwoT2psMygA",
                "amount" => 3_500_000_000_000_000,
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              }
            ],
            "total" => 3
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/notifications/block/1444801", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_473,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [],
            "total" => 0
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/notifications/block/1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_467,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [],
            "total" => 0
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/tokens", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body: Poison.encode!(@tokens),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("error", _, _), do: {:error, :error}

  def get(url, headers, opts) do
    IO.inspect({url, headers, opts})
    result = HTTPoison.get(url, headers, opts)
    IO.inspect(result)
    IO.inspect(Poison.decode!(elem(result, 1).body), limit: :infinity)
    result
  end
end
