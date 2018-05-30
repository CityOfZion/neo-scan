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
