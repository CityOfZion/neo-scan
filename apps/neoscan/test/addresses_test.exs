defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Addresses

  @deprecated_tokens Application.get_env(:neoscan, :deprecated_tokens)

  @neo_asset_hash <<197, 111, 51, 252, 110, 207, 205, 12, 34, 92, 74, 179, 86, 254, 229, 147, 144,
                    175, 133, 96, 190, 14, 147, 15, 174, 190, 116, 166, 218, 255, 124, 155>>

  @gas_asset_hash <<96, 44, 121, 113, 139, 22, 228, 66, 222, 88, 119, 142, 20, 141, 11, 16, 132,
                    227, 178, 223, 253, 93, 230, 183, 177, 108, 238, 121, 105, 40, 45, 231>>

  test "get_balances/1" do
    address_history = insert(:address_history, %{asset_hash: <<1, 2, 3>>, value: 1.0})

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      value: 2.0
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      value: 3.0
    })

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    balances = Addresses.get_balances(address_history.address_hash)
    assert 1 == Enum.count(balances)
  end

  test "get_balance_history/1" do
    block_time0 = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 22)

    address_history =
      insert(:address_history, %{asset_hash: @neo_asset_hash, value: 2.0, block_time: block_time0})

    block_time = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 12)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      value: 3.0,
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @gas_asset_hash,
      value: 0.2130,
      block_time: block_time
    })

    address_history2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        asset_hash: @neo_asset_hash,
        value: -3.0
      })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      block_time: address_history2.block_time,
      value: 2.0
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      block_time: address_history2.block_time,
      value: 2.0
    })

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @gas_asset_hash,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    insert(:asset, %{
      transaction_hash: <<4, 5, 6>>,
      type: "NEP5",
      precision: 8,
      name: [%{"lang" => "zh", "name" => "My Token"}]
    })

    balances = Addresses.get_balance_history(address_history.address_hash)

    assert [
             %{assets: [%{"GAS" => 0.213}, %{"My Token" => 2.0e-8}, %{"NEO" => 4.0}], time: _},
             %{assets: [%{"GAS" => 0.0}, %{"My Token" => 0.0}, %{"NEO" => 0.0}], time: _} | _
           ] = Enum.reverse(balances)
  end

  test "get/1" do
    address = insert(:address)
    assert address == Addresses.get(address.hash)
  end

  test "get_split_balance/1" do
    block_time0 = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 22)

    address_history =
      insert(:address_history, %{asset_hash: @neo_asset_hash, value: 2.0, block_time: block_time0})

    block_time = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 12)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @neo_asset_hash,
      value: 3.0,
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @gas_asset_hash,
      value: 0.2130,
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<1, 2, 3>>,
      value: 12302.0,
      block_time: block_time
    })

    deprecated_asset_hash = Enum.random(@deprecated_tokens)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: deprecated_asset_hash,
      value: 124.0,
      block_time: block_time
    })

    insert(:asset, %{
      transaction_hash: @neo_asset_hash,
      type: "governing_token",
      precision: 0,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @gas_asset_hash,
      type: "utility_token",
      precision: 8,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    insert(:asset, %{
      transaction_hash: <<1, 2, 3>>,
      precision: 25,
      name: [%{"lang" => "en", "name" => "my token"}]
    })

    insert(:asset, %{
      transaction_hash: deprecated_asset_hash,
      precision: 8,
      name: [%{"lang" => "en", "name" => "my deprecated token"}]
    })

    assert %{
             gas: %{
               asset: @gas_asset_hash,
               name: "GAS",
               precision: 8,
               type: "utility_token",
               value: 0.213
             },
             neo: %{
               asset: @neo_asset_hash,
               name: "NEO",
               precision: 0,
               type: "governing_token",
               value: 5.0
             },
             tokens: [
               %{
                 asset: <<1, 2, 3>>,
                 name: "my token",
                 precision: 25,
                 type: "token",
                 value: 12302.0
               }
             ],
             deprecated_tokens: [
               %{
                 asset: deprecated_asset_hash,
                 name: "my deprecated token",
                 precision: 8,
                 type: "token",
                 value: 124.0
               }
             ]
           } == Addresses.get_split_balance(address_history.address_hash)
  end

  test "paginate/1" do
    for _ <- 1..20, do: insert(:address)
    assert 15 == Enum.count(Addresses.paginate(1))
    assert 5 == Enum.count(Addresses.paginate(2))
  end

  test "get_transaction_abstracts/2" do
    asset = insert(:asset)
    asset_hash = asset.transaction_hash

    # claim transaction (no vin, but 1 vout) address is receiver
    transaction1 = insert(:transaction, %{type: "claim_transaction"})

    vout =
      insert(:vout, %{
        transaction_hash: transaction1.hash,
        asset_hash: @gas_asset_hash,
        value: 5.0
      })

    address_hash = vout.address_hash
    insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 2.0})
    insert(:vout, %{transaction_hash: transaction1.hash, asset_hash: asset_hash, value: 3.0})

    # normal transaction (1 vin 2 vouts) address is receiver, receive 5.0
    transaction2 = insert(:transaction)

    vout4 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction2.hash,
        asset_hash: asset_hash,
        value: 5.0
      })

    vout2 = insert(:vout, %{asset_hash: asset_hash, value: 7.0})

    insert(:vin, %{
      transaction_hash: transaction2.hash,
      vout_n: vout2.n,
      vout_transaction_hash: vout2.transaction_hash
    })

    insert(:vout, %{transaction_hash: transaction2.hash, asset_hash: asset_hash, value: 2.0})

    # normal transaction address is sender
    transaction3 = insert(:transaction)

    vout3 =
      insert(:vout, %{transaction_hash: transaction3.hash, asset_hash: asset_hash, value: 5.0})

    insert(:vin, %{
      transaction_hash: transaction3.hash,
      vout_n: vout4.n,
      vout_transaction_hash: vout4.transaction_hash
    })

    # multi transaction (2 vins 1 vout)
    transaction5 = insert(:transaction)

    vout5 =
      insert(:vout, %{transaction_hash: transaction5.hash, asset_hash: asset_hash, value: 9.0})

    transaction4 = insert(:transaction)

    vout6 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction4.hash,
        asset_hash: asset_hash,
        value: 14.0
      })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout3.n,
      vout_transaction_hash: vout3.transaction_hash
    })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout5.n,
      vout_transaction_hash: vout5.transaction_hash
    })

    # multi transaction (1 vin 2 vouts) where vin has the same address hash than 1 vout
    transaction6 = insert(:transaction)

    vout8 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction6.hash,
        asset_hash: asset_hash,
        value: 13.0
      })

    vout7 =
      insert(:vout, %{transaction_hash: transaction6.hash, asset_hash: asset_hash, value: 1.0})

    insert(:vin, %{
      transaction_hash: transaction6.hash,
      vout_n: vout6.n,
      vout_transaction_hash: vout6.transaction_hash
    })

    # transaction to itself
    transaction7 = insert(:transaction)

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction7.hash,
      asset_hash: asset_hash,
      value: 13.0
    })

    insert(:vin, %{
      transaction_hash: transaction7.hash,
      vout_n: vout8.n,
      vout_transaction_hash: vout8.transaction_hash
    })

    # transfer transaction mint
    transaction8 = insert(:transaction)

    insert(:transfer, %{
      address_from: <<0>>,
      address_to: address_hash,
      transaction_hash: transaction8.hash,
      contract: asset_hash,
      amount: 18.0
    })

    # transfer transaction burn
    transaction9 = insert(:transaction)

    insert(:transfer, %{
      address_from: address_hash,
      address_to: <<0>>,
      transaction_hash: transaction9.hash,
      contract: asset_hash,
      amount: 18.0
    })

    # pay gas fee
    transaction10 = insert(:transaction)

    insert(:vin, %{
      transaction_hash: transaction10.hash,
      vout_n: vout.n,
      vout_transaction_hash: vout.transaction_hash
    })

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction10.hash,
      asset_hash: @gas_asset_hash,
      value: 4.9
    })

    transaction11 = insert(:transaction, %{type: "miner_transaction"})

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction11.hash,
      asset_hash: @gas_asset_hash,
      value: 5.0
    })

    assert %{entries: entries, page_number: 1, page_size: 15, total_entries: 10, total_pages: 1} =
             Addresses.get_transaction_abstracts(address_hash, 1)

    assert entries == [
             %{
               address_from: "network_fees",
               address_to: address_hash,
               value: 5.0,
               asset_hash: @gas_asset_hash,
               block_index: transaction11.block_index,
               block_time: transaction11.block_time,
               transaction_hash: transaction11.hash
             },
             %{
               address_from: address_hash,
               address_to: "fees",
               value: 0.09999999999999964,
               asset_hash: @gas_asset_hash,
               block_index: transaction10.block_index,
               block_time: transaction10.block_time,
               transaction_hash: transaction10.hash
             },
             %{
               address_from: address_hash,
               address_to: "burn",
               value: 18.0,
               asset_hash: asset_hash,
               block_index: transaction9.block_index,
               block_time: transaction9.block_time,
               transaction_hash: transaction9.hash
             },
             %{
               address_from: "mint",
               address_to: address_hash,
               value: 18.0,
               asset_hash: asset_hash,
               block_index: transaction8.block_index,
               block_time: transaction8.block_time,
               transaction_hash: transaction8.hash
             },
             %{
               address_from: address_hash,
               address_to: address_hash,
               value: 0.0,
               asset_hash: asset_hash,
               block_index: transaction7.block_index,
               block_time: transaction7.block_time,
               transaction_hash: transaction7.hash
             },
             %{
               address_from: address_hash,
               address_to: vout7.address_hash,
               value: 1.0,
               asset_hash: asset_hash,
               block_index: transaction6.block_index,
               block_time: transaction6.block_time,
               transaction_hash: transaction6.hash
             },
             %{
               address_from: "multi",
               address_to: address_hash,
               value: 14.0,
               asset_hash: asset_hash,
               block_index: transaction4.block_index,
               block_time: transaction4.block_time,
               transaction_hash: transaction4.hash
             },
             %{
               address_from: address_hash,
               address_to: vout3.address_hash,
               value: 5.0,
               asset_hash: asset_hash,
               block_index: transaction3.block_index,
               block_time: transaction3.block_time,
               transaction_hash: transaction3.hash
             },
             %{
               address_from: vout2.address_hash,
               address_to: address_hash,
               value: 5.0,
               asset_hash: asset_hash,
               block_index: transaction2.block_index,
               block_time: transaction2.block_time,
               transaction_hash: transaction2.hash
             },
             %{
               address_from: "claim",
               address_to: address_hash,
               value: 5.0,
               asset_hash: @gas_asset_hash,
               block_index: transaction1.block_index,
               block_time: transaction1.block_time,
               transaction_hash: transaction1.hash
             }
           ]

    assert %{entries: entries, page_number: 1, page_size: 15, total_entries: 1, total_pages: 1} =
             Addresses.get_address_to_address_abstracts(address_hash, vout7.address_hash, 1)

    assert entries == [
             %{
               address_from: address_hash,
               address_to: vout7.address_hash,
               value: 1.0,
               asset_hash: asset_hash,
               block_index: transaction6.block_index,
               block_time: transaction6.block_time,
               transaction_hash: transaction6.hash
             }
           ]
  end
end
