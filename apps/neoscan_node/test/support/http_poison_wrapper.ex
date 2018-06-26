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
    ],
    "version" => 0
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
    ],
    "version" => 0
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

  @block1444843 %{
    "confirmations" => 932_272,
    "hash" => "0xc38a8b9a4ef4b8ff2dea5d6137448b53e57e6d038c1618f580ef9b2d8ed79a97",
    "index" => 1_444_843,
    "merkleroot" => "0x14b7d26e9971c23805ac1da16f0137c7009f118b51c905353c2661253475783a",
    "nextblockhash" => "0x2f4d2147e6c9fd96b8ec4628bc2af9bde01dd521d976d88e678bd240b04f5616",
    "nextconsensus" => "APyEx5f4Zm4oCHwFWiSTaph1fPBxZacYVR",
    "nonce" => "01bd450bd0b8471c",
    "previousblockhash" => "0x13a8d29859053d3b8d9033f3e72db7e4f0e15859e044ba61a0403350ae8d835a",
    "script" => %{
      "invocation" =>
        "40dac543e10f911a80b242437eb3f805f8d7db6cfdef779a089ef72583a7864a16d4bd5522d1bee451c307328640ccbbf132c87f25bce1ae70267316143c84e6894095b47f43e9687992bf59003e914911d340e71780a03542eb00f1f60f125308736af878b6a340dd1804e34f633f656e2362515fe8e15358b787993a3398380a0940ee5d613ea5eaa61fc16e3f83ce3b080b6a0585473fc5313232f9dc4a8806f4cc655e07ee2087bec218c7c34d82e3adb24c6b47d1c28c6c1f5cb673d87ce7be2f40659f3cfeedf6528d2117a779a54a2c5fd1c639a32121a41fb97616bd065932a445e8e1f36a8db98fe769ad4ca8e0c5b0ae9dccef0fa907db7ca539fe86b7c8fd4061cc3f1580ac41f227bff3c9f54c9e7c2aba7fc450025bfa513fef28392d1131c01bd7ebc51deb911f5a3247afd7bac0b927b00416fbca2bacd216cc5e73d54f",
      "verification" =>
        "552102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a7021024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e2103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c2103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e89509357ae"
    },
    "size" => 8726,
    "time" => 1_507_466_032,
    "tx" => [
      %{
        "attributes" => [],
        "net_fee" => "0",
        "nonce" => 3_501_737_756,
        "scripts" => [],
        "size" => 70,
        "sys_fee" => "0",
        "txid" => "0x2519fbc6c16d96f9a776cf39b46c91290ec82829ada692f139fa339b4632b2af",
        "type" => "MinerTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ARtmDzcTZxHCYydqFxFw31d21CpSArZwi4",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.001"
          }
        ]
      },
      %{
        "attributes" => [],
        "gas" => "0",
        "net_fee" => "0.001",
        "script" => "00c1066465706c6f7967f91d6b7085db7c5aaf09f19eeec1ca3c0db2c6ec",
        "scripts" => [
          %{
            "invocation" =>
              "40f99aef575d5e2be3de117c80fe3b99411f2a88f12983c33eb2d6bb88af512d4e209ff4f1ba4ea4b7dc21ff52285c8f7a9059cfeb4015ee497b5e6497184ec9d7",
            "verification" =>
              "2102f2cafd8d6219ecd140198fb5d7f7ad8ca2c3dbb09950e6d896eb319867505a0aac"
          }
        ],
        "size" => 233,
        "sys_fee" => "0",
        "txid" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
        "type" => "InvocationTransaction",
        "version" => 1,
        "vin" => [
          %{
            "txid" => "0xc8c9696476091fd63f4b0214715abe3eb10f4882a2959d4592c1f3cace800c24",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AQcxz3gj42aZ74ymenykJuiMKBZqarFX6y",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "39.999"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x0a4047ef6af9f9d4a11ab0fd20ae3e7ed9611248c73a3d5201b6e81cb48a66bf",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "406b4782fad6eb34a5b966c6a37dbb5e609a1fc0d1e1168549a86cd0ba983e40d6be03219a76c71202b6f3a1faa610eaba2673c918ee7e2a5948c341ea03361d2a",
            "verification" =>
              "210219cf752f43109139f399bb6188d7d2a7043255cb3529e3aa50679da2e9b0ac60ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xa2e21393a593cb16340d2cd99a385c7144511027a5e76b552f79193b9b4a3269",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ATkhBJKYoNt9jpQTcvJ2eNXmg8fwQD5DZh",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0027566"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x55d0fa2688bda83624cbe4d7be60e4525f843d6d8887c23d237c898b6d45ff81",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40fa29fe8d5bfeaee31b82ecbec2e6c2d52987b2cc0e602228caa8714f0781cfbfc531b9e5894c81ae039c387970f99cbe4fe2f7984421dea5140a0a1a76c055e2",
            "verification" =>
              "2103051f9d8436d73ecd208dfdf334ca6058f82f95aed6b46038d2cec610d150167aac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0x5b18b2b20b1fab7277ef0864851bfb7c522afddd2bb2c32b4dfbc86c74bf84e1",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AVNmT7s4khwaFqNRSDy8G4rhfwTVSBQQao",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0021392"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40693dfa197ada445c2458cf875744a913f82189bde1c733a8105d5985362aaa89661e07f16b5dcbf0ed1f4d644149ce1c1fa99cc01ded0eadc291bc6714956b95",
            "verification" =>
              "2102513ba0684ca7724c35399cdc8b87e5f0a770778e6f34700fd824b14de54b5482ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xafef3f6d901bfab3a70e4a1a05bb403a2e067d543fc05717fcb1827db25b17bc",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x6e3a8137ac85f2b18399cb05f515d391ced63b3f5ef9daac8ad5a2bf56fbe66e",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AWrAn2pkW4LPj8qvduJsBxxhWmHEPNrYTB",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "244"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "403c0ca2e11ed8b766742cd02105169595d3c8433d57e4f7c9e0614881bb4e0cb7871752ed1f304df84812ef20f22c17fb1e2532680740469c781a15d3f20f8e50",
            "verification" =>
              "2103c6b038614a23e6942e21a74bee6fe18d3b6b399a29da8ca3984bf5c65753d50bac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xf2d975f1d2a0f8540a511647822329decd6ff57af8e165c9e640258790ac9dda",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x58db4042cda2437a123fd3055a282e0b6b299e5327e194d527fcba50fb80cbc0",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AZ1p8aZiAVvhjLVuJT6KU2pnyjg9nquxve",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "27"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40a1b768f921f23601f72e4a28aed8d476e4d82d4a5019663596afee847a4ebf52f53444e7b77e787e4b78369df1b2042e9585abb40ef325777d047ec67eca8d0e",
            "verification" =>
              "2103239a23983f2e12356368093c1d53246c25ac7c664b73ff0186ec3002cc5b4d0bac"
          }
        ],
        "size" => 236,
        "sys_fee" => "0",
        "txid" => "0x079da384cd1dda07cf4ead95b62dd73976b5d948966f22bb146e57f8a2cedd43",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x692604297e6c009fe16555861e3d06d6dfc09aa6e025410936b45e8b7273be60",
            "vout" => 1
          },
          %{
            "txid" => "0xa6d619e0aa12c8cdfff5fcd55c31b2e4f39e24e010b9d62a462470610a484afe",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AbNk2xyU5yytzS3g4AFjmHFyv2DeCKANQg",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "27"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x9cad031536e4c216c93528b18f5ac86cdf36a8788556d90649dc7b2c528a45b6",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "402da779f7f530c2d28bb5603b7cce0fccf70dc0e724291329082bdd40ea1bed26cf4331ec0ee155516f9506478e7687d2b97e33261a176d63097e20b93a7d68b4",
            "verification" =>
              "2102d7fbec159bab4b0a9d0d94ffa96b7d4ca706d9f004b6f1ca9e050fee1fd606fdac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0x2446886c7126d8916a75db66d740d577fc8b1ccc0d011fa44d8cdf72d77788a7",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ALWPnZ5D12m9FeZcc8b5r4HPtjF3wUwawf",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0004635"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x89d752c776896db20476ed273c0d2e74d66c642c834e535ddb10a99f4384fa1c",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4014edb2cef5bbd961549feff5f5b605894dcc70521916b8b72a644fbaab0f8f2e28a07e6a03e2cac254e3c4bf67b81a14ddb69be60b68ac972b3daa53106f0002",
            "verification" =>
              "210252e98486d8529841323abf6e56b547b940289bdd534d214d720952a00184177fac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xa87da448a524b45a2f48994ba45d5df3111266cd64f13345050fd87d70dde05d",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ATF9L3CmDHaPAnPRHMJPzQvRXgCbzbB91e",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.00034374"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40eedaaa9ee2cccfd2254632261c53fc4356b227e5ddad70cb6bb449ad5171db313d9918bbdb6845a3ffd5e9ba6b7aabc5aefe1a1326c74b786a79244c8ea6bc17",
            "verification" =>
              "21023a7e222acdaf93b4138af8773d6737f7d869aa57b86f98a7186917e244108eb5ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x61f4d44b095b5885038b67e2547b7d2e206b20cc741a640c872563f4e34bc919",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x90467659ae4481480220e25e9b1e1c0bf14068ac9cd04242ce06ad9e01f95448",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AdzbXPfmYmB5qWuqraeSUiBMby3FPsCm8J",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "29"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xd5cd5365e19be3589fb4b5c3233488d5acc8eec31dcf86f3e34eccff43a2b831",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40a8df815674536210f63c6d852b806c9df0dc15e243b72ba096c57f770bb8f194bcd59e1b4bfe942963029a6122a1fe92a112071470535cbb3e83a9be4312ed86",
            "verification" =>
              "2103cba4c22e4685938d52c0cc8c7f7c046ea9d77cbdbec1e5fc3658368fe46a9128ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xc2c67aaa5f495a9b5813883abc45c8cc2b34f763b4c50300a4bb69d9465ae4bf",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AWNLAtjmNXAJSR9p7P8APBri7jpYRPMwUA",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0443568"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40db5089257b72b7d34d167628049d810f947ba51e87decbe3d35b3959b47ab275214ad26ebc7d9263d8f664fa5eec51d724f817a767e035e7156fa2ea3e2f007e",
            "verification" =>
              "210227c9ee83282eb841cfb6e541659927ce9d00859dc98b5c47b1220c2c34b20897ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x5cab0d9cfe835fbb0c991350025852fee229ee88e199c2ba2acaa9b89cba4af8",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x82928ba10749dc59641357ed31f673c650875674b1ba82d0871befde98d06054",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AJdCehHv2cw7kThRv9N2MF3E5Z75PLp7dx",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "14"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4005ee1b177617376e5ec07bd2eab922bcf6bbffe7ec21d4a4b7dc7cb8779cd38874b923cfb3cd0de31862b2bc15b839a89bcb259378fc3008766ab1db92ccecfa",
            "verification" =>
              "210277eafd9f027aeeb93b493da854bd39bed4ec10cb3a45baa6e06ab0eb8bd33c5aac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xec826a17489f2c0d59a3b4f824e32b100264c1c6ccfc25f3f2c877f335d13837",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x6979685273be0ba45bd4e9e84d5466983e890e69aba255fa9bddb41e0538c9fc",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AYFozMkej9PMGRr9mrsJeHPqyfUgdEvAqH",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "100"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xb5eeeca3afc6c2643a9bde4a77ce1b530a8aee7938e501629babfda2a7988441",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "401c0dbefac578fd4b5bce187b64f1ab5c7f719967c36af9001cb53e841875cd65573c1b139c31670f7ef3826f9308755d842442d81521b2913d0306d7c5261adc",
            "verification" =>
              "2102b777dc85f6566f56c6921138e5339d1bcd865827992ee13fc60ce49307e9e63fac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xa327286c2212c1f4b0aee669d639b9b88649de0dfdadc4a3092bf84c9b69ae0e",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AWQfk5Uc5dWamFn1QpasPNmsXKdUsMc9Np",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0023652"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x36f254b56f0eed446790027c11ab98e65a7aac018abf85e2b89b3f9b69d6570d",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40bcf2f42e7a222c9b3f6c77ba4b966581c3eee4aacda2be0189e5be5be9dc7eee9956116cc0d641263bf632326c0375cf2cd2c5cc711debdbf35e55708ff0fe73",
            "verification" =>
              "2102b223c25ae48fce084d0f2d3d1bbeb89a4a2265e38424e8e354e2f6a1fd5ffb8bac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0x82189c45b562958d18779f00617d1c706bb72044b4b8d51ee17b21b325a43900",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ANn2fv1MiLqDCUfmqZVYsPpCQAsEsH946m",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.02951586"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x7d6df76d22ef0fb2fd3d668e24b8c0e37b21bd606eab4bddddd3626159c119b4",
            "vout" => 0
          },
          %{
            "txid" => "0x4f5d909d1e0bd4c3bb50631d3cbcceb820cfb5653e8c5f4f3f4c9584a5d0d5ce",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4040dd37bb5467780c6ba5563e0a7fa932fac9ebd057ab48702662544340d66a6d44929d93a8f72b2e35b0d45b272698da983c83cea63639355a678905eb40bcda",
            "verification" =>
              "2102ed39359bcef206409542663ae3849efa276e0e3b16f3a7bde4a9439ba1974722ac"
          }
        ],
        "size" => 237,
        "sys_fee" => "0",
        "txid" => "0x23a369f2ba2d806b6d27f47c3ff94f875c3b2f280187f87bbab7503586cd2766",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ARfXBdJLu9GpKooDDfGE3vHotpNtuK1Kou",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0024928"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4054fad20c8a0fd28aef5583e6bb9c4c2111bca51776cdef1e9f9e153d9947b05a44cb7bb53e354d69581bb7248bcdadbd081776222166dcf80208c074c402d54a",
            "verification" =>
              "2102e08b882f6d6660304c24bb0cc6e9e5c222530f6d32a57c2c97d8cbee9fa73f69ac"
          }
        ],
        "size" => 262,
        "sys_fee" => "0",
        "txid" => "0x14572752e56c4876d0e4f5d6c356010bd22e28385b24f7ef52c1731aea9408fa",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x223529d32b797db28ac505667f23ee753defed87eaac7aeb496bdc1e4ef33e4c",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AVWyFZeLKioKvsWDvVDKc4ECnWURwhVsrL",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "3"
          },
          %{
            "address" => "AH49unXqx7MvkhbQho5L5K2hQxQzCGoeBY",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "3"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4049eed4125be1bc6a38c2e1dad8a4d71f2c071dd5e25616fca8b05ed678dbcf236614be40768e1a61490948c64cf051bb0d572c78fde7c14bce8d55af0213e5a8",
            "verification" =>
              "21037ae61122cc55f1fed885b09570033e7067ac55c70fb3edd42da6d4fd6769fe9fac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x283a28d499cd6a03f5b58ce7afbae07a54ae3ab695480092ff29d925fa741e0e",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x90c0341af375248041a8091a889a88d071e8e934a3e14b87c4f039c08c1b9251",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AYkrR4zKNM4f7BbGuy33WmD3AXEMvLK2Ku",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "34"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40b74bcc8d08c5d064ecb733b20957185e5fa1b351005ceabe90ef4c8c7dd2eab9b4874d3a7efcb869b78be73e71327d678fb21a3af7b0c1ccd340e92153fe2d78",
            "verification" =>
              "2102d3168e531de50c6bfd31e139b8e768de28a2b80126852d9d3852ce33bbaa08cfac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x00fcd545e480f3df88c846735868e86a41136a2ecb2585326d67d3f1a14965bb",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x3f6808a3ad51f5e448e5988152e947e9288c3e9bbc53ba53cb92d2fabc21020d",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AQHwt4veLExu17xM6JYntABGY6F5KHZLqd",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "34"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "407a43dde475c202296a5e76094dc1c4091c63ad00e4f872819feefb83d4caff6b5dff44f2eb27d9c0d4f7d503fae0a6b401620a6d9f20434a61f8f77609702534",
            "verification" =>
              "2103819ca5f9a347183d6d9dea3a82247b945bc90fef931b41924417146d3d3ac007ac"
          }
        ],
        "size" => 262,
        "sys_fee" => "0",
        "txid" => "0xb53eca9b8136be53b07bbd5632c6897bc13a88be05a56e2b273857f4081118de",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xf903722f846cebdec305b7d52029cd1bd022af88c999d78c85529e24546ece28",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "Aa9WRVhiPdMzEFz29RtLhZfAjw3vGQFWhe",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "20"
          },
          %{
            "address" => "AHBRwoGQ9MJvEfc1DkLiGrrWKe3Vukpyds",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "47"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4027778cb68f354d16a7025b7f9fd5c879c6d778a9c42d5437c39f9df65d55921229cf5e44da68e0cd1aabc75edb390678542074cce01f0d60e11627ba498cb0ec",
            "verification" =>
              "2102da8a1f0bc9b88dfd5ca627f1aaf46469db6d363cf8fc16efed8d398bd3e2135bac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x19a6a2482f7c48109d254c0df9a09b141c4ef220e8562d88d21cc6ca503924af",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xeb2e0969a8a9988fd9adab62ab6f70fbf0adcd95859e4073890ea36856b5115f",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AXtwwnv5xBcGdjKLLsm4e6Q4298vhBXr33",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "184"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "407e8f19736b6f42d9f8516e3571618e43bac7706ea325981a36d6acff8c8ff4f1441a1e025a6a77f4163201fecb102635452ba19fbdfeff76f9b5db1f065ba645",
            "verification" =>
              "210248dd46da41b4cd3d83e66741b1c4cc0ace2459a8d1e31e844c3029ce9b242bcfac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x0029b74ca75f9adb9fb64877961b65080ecd69cc116d15dd43290466084bc80c",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x70f0b11da845e01c91d30b2beaa3a795b368eab5bc462a3165db6e3395d77f8a",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AdxKe5QNQt9cyvijx1HpKa1MymaZxF1H2H",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "294"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4024debbf5585bd6ce5bc31d8134c44a9f361220bd37d10be15cf8abfabdf10132285fc946716f5e5527fc53f918f28af9e74c86b7b7198114666d2b6bd1ccc5f5",
            "verification" =>
              "2102a1dca5e1c2a3ecfcc126a661d911ab6d117a4283614dbde36cff0ce860ef5c38ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x705d58f10ce2f90c1abf358e5f774c0fc2613fd35fe563e8b2efac38cb7144fc",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xa2eea2ad641324212c7b21280cfa6b38afe30ebf1566b5459c411ac3a010e75f",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AXthcdiKD8o9qofTFUcgoohQkMB3rZpfou",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "27"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "406b23fd68ce42d30a6d4e7f675ad90e14a1e047a29ae32a1495ab23c57a3991447cfead8a5ce7e39374f2286423f159ac2d2519c13bcf8d668263cf7290710bf4",
            "verification" =>
              "2103b0ef00acf65e7c72b03d0fb99942dc50321329902161ef46434dfca9e9318db2ac"
          }
        ],
        "size" => 262,
        "sys_fee" => "0",
        "txid" => "0x9ab972de04b253d3622d09298afb1b86b440498151902c9e153e654db96aabb6",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x62d3e114f28d279b412f9755624ad693c159fb428075887cae00895565544e88",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AZnTptKwHL6pHrASQCvR9NZJNJzKS5yBdJ",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "800"
          },
          %{
            "address" => "AFuiwwJBo1jLVHYSeSGrbsS5CfifoQMaGN",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "7997"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40762905b4d76148abe6bfb36cc1414489f1930f692c40f67e75ffa991ee0ac37cbbe79d3a0c5ed2f983f46be8adf0b2403ee7e0a933da0e31f04538cc1dc9ee07",
            "verification" =>
              "210341198b8d302ad17323471930a24c573ef9f142bcba0885236c371883bdae11a9ac"
          }
        ],
        "size" => 296,
        "sys_fee" => "0",
        "txid" => "0x5e49d7a7693cc369a0ebec830ad465fe16723d8bc523666a28ed33c14ebbac20",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x8b246d442f8bdd7ff8d88e1bd780b6449b058c6bc79a93dceb5523d610e49831",
            "vout" => 1
          },
          %{
            "txid" => "0x29fc676ccc314d49ca47c9a984901e5b4b78b330d78cae9c184acb46504ef3f2",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AdnsEEfYo8dYLAvkxHv41cu4Jnbu3wk1Wv",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.002"
          },
          %{
            "address" => "AV8kbruyQp5tuPUiLnUShzLXgzS9U7q8rm",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 1,
            "value" => "0.0005759"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x93bc7f013d71c88a513eb482f4b95a2e59812c65ac5179a288dc31ebc1d79bab",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40c975f2ced6cb4e710d0bfa9221f4a42d8cd88871bdab743c44667229f88690871c9f93bb34902d510e6fe316d5a7f7f5a585711c67f6c89070c87e169a0fd93a",
            "verification" =>
              "2103a2d10c4990c393b483059339c19889079f7a5377fb0557076557d0f6109c30c8ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xb74db111b26859f86f7ccc3f5c4ac4efc50f6beb082b219f217a4c7086ea63b7",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AbQDA2Ks4RRCCL9Lo3uyEQv286bXeCadHv",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0009393"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "401554e07f7a49b8cfac8fc80c849cee02c9f311f4e95728ae02e9958aaf496832b721fefd2cfa69f1ec5971493ff29a524315e07591e3b4edad62c6002542d08c",
            "verification" =>
              "21023a359fe70274b790d2a6b7e049c9c6ac7c2020e972ab24db591db69b95e0ca92ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x556310f4434ebc012f3f5d2a4ccbd3d99638ba97a7e111029ae1bce22b555511",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x34709f393683f44a94a67172a91f95d6f8aaf4319df73fa428cc7ead2fd82d31",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "ARjixduLKfSCRdm6CFqriri7n4D3AFUcLC",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "11"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "405530e033c0b3399904e4e10fa3c4f977694721189b7094877db53ab94837d90024783e0e20a3470bfa27d0c6d21336903d000af5b05e68e36d64c5dbd9c46974",
            "verification" =>
              "2103867a80565182408b42add7d11f79939d3f2a2918542b500b961d95840044df09ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x5dcd724ba49b959d4928aa11b07c7a1883ee7f6dabf0ec1cfb66bd19eaacd8f0",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xd96055dbd28f5f1ea7f5a79bd29ff1a4a7523bae3a2a48d0e7e1047d81c658ed",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AJFq4odEDo8AgihLaDE25J25wjFweAQvAY",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "1"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "404dfcc9fb6722281094316737a47f3bc46ee840a1e9e30cb1ed5d772d98e0844cdc4f24667de07367a225487b6f273359c89bd9d06c53f1ca86b620ba57e84357",
            "verification" =>
              "2103818db76748c12a6d1cf8d0b09311e3f395b9143ef3ac20cadff4de8671a8a2f6ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0xb74077de94d1a80661cf39949d104646986fd2396bb7050f538d9774bc082767",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x2a4e4f4b9b95bc720cf513ec407912eef889f6ba125cb4bf9f369af33d6528e0",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AJTCe8h8CPJ1pL8ia3PLFfgK83ZaA4TgLQ",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "82"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0xa1d3e6a8dfa0fca013f5dbc19d5e115c3419bd4ffe2c33afbfb8480688bb3cd9",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40ba692e0e03aa36944b32a7ae9774bb0f15e18b5ada88bb2518a3676574cca6f21cacd94d04a8304bd5af291f4c6728c422a812a2563a319d24e2b9c79e4b8954",
            "verification" =>
              "210247f6b0f5dd24c5394324a30e0e3740d4db5ef4c05908e8efd27440b06cbaa1feac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xf947031a405fe308708f655d6689acca038e83d4d22a3e2a576268faafddb838",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "APoQfup1hRfLqvGZ1xGbufv8Vc8Gxu1KhW",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.000201"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4038db74f8b9060ebd7ca8f42013b376fe3db3cbdcb761adcb73d72a971df749997348f8b07c5080455beb03c975278ca54e6db8c5cf44f024352fcf5b4121b631",
            "verification" =>
              "2103621f196104fe3c9ae14ea66d5cd69591671c53c642d03be06e5d168978f2e730ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x0940724edf8485937f5001fec4dd9c1a67ed98292c606cd6e799f05de47d2058",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x10d13eee596e9ff14474da34b9e1a9c5a007fcf56e7e0cb566914a3b2010ce19",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AJfvGCfXH9xE4fUEYvvzKV1nMRYtpuADuK",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "27"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40c1df711e77994fe4820b5cdcc4b6b59a25f53d58e781193eb888eec236cf9911560d863f6173c398b9a7220f90ecb0ceb504f0b95c2738f9f427d177f4ce9808",
            "verification" =>
              "2103972dcdf9596004da7a63749c604420edbcadc00dca3df996c55f330654757439ac"
          }
        ],
        "size" => 262,
        "sys_fee" => "0",
        "txid" => "0xf8e045cd8ae72d9de2f31d7328f9e2a391a03a6144587805a55699bc8cbab9a7",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xc175dcf7c2be61236eaecada3830352da06521ae0f9ffd4d5544dcc8200f3a6a",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "ALHupom7Skv6eLE2pFZYkfEae356LQzaQu",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "10"
          },
          %{
            "address" => "AMya9cb9Y3ADgCrvpQoCgWfTGVo5Qp4UQV",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 1,
            "value" => "5"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x3b16b994603a3b273643f08e58424d168cc173f992de8e877d8774fac426eddd",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "409fa1bfaddf9b65e661dff39b42b47cb999984089a1b178f851a4eae64e72381d19f6d53d2f53f1d880bfaeef1243cc1b68eaae5d105ea31f0a5d641d9fd91333",
            "verification" =>
              "210395c38fea3030b834ba58b9138fe57ab31a9e54dbb22b5a0ad185c06bd814bb06ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0xd597c8d68c410a9db4b01f2ce30295f241701fe92a961101391e8bc71ff2ae43",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "ANrwNBSBcK2gj8QY3Npwycnnn2JRt99ByE",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.00005632"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "40b3aa9a8151df4070717cc6b49d29ff51ca1361a84b84db4264f6269ccf64692ef59297d1196b0099162ca9b8445b40931aa2fef267b00417ff785c147a5a7a4e",
            "verification" =>
              "2103695226b7e4d603c59ed8cea79266c96168ec005834588d73b9ec9a96fcdc5c38ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x0c62179ae24625a8dff48ce43722d0fe2574244ce5778b955d270d6e0f37570d",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0x31e01982397763ed6976c8ce69ff06f2626a01b18a25cea26f7bef497a008308",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AYq7xEGU2WEnAuZ57LyCz7GNw3Spwe97rF",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "34"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x5f678ea8fc68113fb0567101bda2a86cfafc2fd56bd0182ad34c5765d90ca202",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4037357c429153da13faa99dd6a0947baa7e45cd852b45ed0eceba88b4c8e78ad2ed3a8e67007a52ea936c98dcecc8650c12cd89394258f6131d415720a367a2ce",
            "verification" =>
              "2103e650018239987114419d400707263359c9c25833fd00e5492f04cb136c209f82ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0x747d16129e12ad72bd0a7b23d5d0648c8c32cb96ceb45816bb7dee8160c6de77",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AUi57t9R7AZa9rmTtzpgAmwhUaxpBY8cNQ",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0017812"
          }
        ]
      },
      %{
        "attributes" => [],
        "claims" => [
          %{
            "txid" => "0x9da9a44650277823b3065bab1e7409fc22ca7b987460714708db3e7803b059d5",
            "vout" => 0
          }
        ],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "403f9859c040b864e29b6aa0736f8284e1885bb0c3c929d6f985aa55d6aeca8cf2ed116d22ae5eb7249931d6673d7d1a032453dd34caddcc28fb804d2c662cb1bf",
            "verification" =>
              "2102bc6b2a99b949bf34e308aea18f8fdccf555ac72b8bc7e3ed6997040b04e9ca77ac"
          }
        ],
        "size" => 203,
        "sys_fee" => "0",
        "txid" => "0x806bf29a7030057ab7543d6ee38a3e08827a5c2bc6e011616841c75bc57666cb",
        "type" => "ClaimTransaction",
        "version" => 0,
        "vin" => [],
        "vout" => [
          %{
            "address" => "AVNV8JichWhDCzFpJqVgqknjEMvxo6zUPB",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.0018534"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "4062ab6dc0ed79d8f354c8f9d8602d256a097474c071237cd7d7be6f1381f0ef3a2d12d91e156a2ef1689afa5f5f25c852c27f6e560af5e2a9961e9a71e6a52635",
            "verification" =>
              "2102e01c4acdc3d3c6948e931cb3076a00a1492a0478a77a7a4d3106173fa225160dac"
          }
        ],
        "size" => 262,
        "sys_fee" => "0",
        "txid" => "0x289846931ffe7734d261ee983958cfb1990e88fb838f14599a8221a117a09075",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xbf1f288da0bb14ee1d95b59c5fb41fb9ba684f4d2736c50cb88fa8e1724b18dc",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "ATSdbaQtu9Zr5eEmWuEQNQbQR4xgPkPVbi",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 0,
            "value" => "0.01"
          },
          %{
            "address" => "AeNzkZzj5SSwo2bAN1xf5YE7m6NbVSoQcr",
            "asset" => "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7",
            "n" => 1,
            "value" => "0.041968"
          }
        ]
      },
      %{
        "attributes" => [],
        "net_fee" => "0",
        "scripts" => [
          %{
            "invocation" =>
              "406179f502da4a6afb2bc4de3b4bc55f2d362b634a6f9777fb78973fe07ba403fd701d1be606efbe5f3918d2c883d17c9ef59625de064a6ac92fc927b0f8f8f7a0",
            "verification" =>
              "21039f52e94a1ec7b25f63029ac995fa5ca9c982aef14fa6b24ac25defc45ca8d2b0ac"
          }
        ],
        "size" => 202,
        "sys_fee" => "0",
        "txid" => "0x587b7ebc6fd4389537b7d94fa8d7895a05b0aa7473ceb27937dbc32bd180705d",
        "type" => "ContractTransaction",
        "version" => 0,
        "vin" => [
          %{
            "txid" => "0xba43b35614410522b8ac6d900a7f507387e32a2dc3235a1a8f239e5d9b13acb3",
            "vout" => 0
          }
        ],
        "vout" => [
          %{
            "address" => "AR3Y5au2dN5NVpUdrRzq3a8w6ebN6yR7Wr",
            "asset" => "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
            "n" => 0,
            "value" => "34"
          }
        ]
      }
    ],
    "version" => 0
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
    "total" => 1,
    "total_pages" => 1
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

      {
        :ok,
        %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}
      }
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

      {
        :ok,
        %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}
      }
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

      {
        :ok,
        %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}
      }
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

      {
        :ok,
        %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}
      }
    end
  end

  def handle_post(%{"params" => [], "method" => "getblockcount", "jsonrpc" => "2.0", "id" => 5}) do
    body = :zlib.gzip(Poison.encode!(%{"jsonrpc" => "2.0", "id" => 5, "result" => 200}))

    {
      :ok,
      %HTTPoison.Response{headers: [{"Content-Encoding", "gzip"}], status_code: 200, body: body}
    }
  end

  def handle_post(_), do: nil

  def block_data(0), do: @block0
  def block_data(1), do: @block1
  def block_data(2), do: @block2
  def block_data(123), do: @block123
  def block_data(199), do: @block199
  def block_data(1_444_843), do: @block1444843
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

  def get("http://notifications1.neeeo.org/v1/notifications/block/1444843?page=1", _, _) do
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
                "addr_from" => "",
                "addr_to" => "ATuT3d1cM4gtg6HezpFrgMppAV3wC5Pjd9",
                "amount" => "5065200000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "",
                "addr_to" => "AHWaJejUjvez5R6SW5kbWrMoLA9vSzTpW9",
                "amount" => "9096780000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "",
                "addr_to" => "AN8cLUwpv7UEWTVxXgGKeuWvwoT2psMygA",
                "amount" => "3500000000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              }
            ],
            "total" => 3,
            "total_pages" => 1
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/notifications/block/1444902?page=" <> page, _, _) do
    page = String.to_integer(page)

    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_473,
            "message" => "",
            "page" => page,
            "page_len" => 500,
            "results" =>
              List.duplicate(
                %{
                  "addr_from" => "",
                  "addr_to" => "AN8cLUwpv7UEWTVxXgGKeuWvwoT2psMygA",
                  "amount" => "3500000000000000",
                  "block" => 1_444_843,
                  "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                  "notify_type" => "transfer",
                  "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                  "type" => "SmartContract.Runtime.Notify"
                },
                if(page < 6, do: 500, else: 271)
              ),
            "total" => 2771,
            "total_pages" => 6
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/notifications/block/1444801?page=1", _, _) do
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
            "total" => 0,
            "total_pages" => 0
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("http://notifications1.neeeo.org/v1/notifications/block/1?page=1", _, _) do
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
            "total" => 0,
            "total_pages" => 0
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
