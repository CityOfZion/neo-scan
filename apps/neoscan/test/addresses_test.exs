defmodule Neoscan.AddressesTest do
  use Neoscan.DataCase
  import Neoscan.Factory

  alias Neoscan.Addresses
  alias Neoscan.Flush

  @governing_token Application.fetch_env!(:neoscan, :governing_token)
  @utility_token Application.fetch_env!(:neoscan, :utility_token)
  @deprecated_tokens Application.get_env(:neoscan, :deprecated_tokens)

  test "get_balances/1" do
    address_history =
      insert(:address_history, %{asset_hash: <<1, 2, 3>>, value: Decimal.new("1.0")})

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      value: Decimal.new("2.0")
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @governing_token,
      value: Decimal.new("3.0")
    })

    insert(:asset, %{
      transaction_hash: @governing_token,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    Flush.all()

    balances = Addresses.get_balances(address_history.address_hash)
    assert 1 == Enum.count(balances)
  end

  test "get_balance_history/1" do
    block_time0 = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 22)

    address_history =
      insert(:address_history, %{
        asset_hash: @governing_token,
        value: Decimal.new("2.0"),
        block_time: block_time0
      })

    block_time = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 12)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @governing_token,
      value: Decimal.new("3.0"),
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @utility_token,
      value: Decimal.new("0.2130"),
      block_time: block_time
    })

    address_history2 =
      insert(:address_history, %{
        address_hash: address_history.address_hash,
        asset_hash: @governing_token,
        value: Decimal.new("-3.0")
      })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<4, 5, 6>>,
      block_time: address_history2.block_time,
      value: Decimal.new("2.0")
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @governing_token,
      block_time: address_history2.block_time,
      value: Decimal.new("2.0")
    })

    insert(:asset, %{
      transaction_hash: @governing_token,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @utility_token,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    insert(:asset, %{
      transaction_hash: <<4, 5, 6>>,
      type: "NEP5",
      precision: 8,
      name: [%{"lang" => "zh", "name" => "My Token"}]
    })

    Flush.all()

    balances = Addresses.get_balance_history(address_history.address_hash)

    assert [
             %{
               assets: [
                 %{"GAS" => %Decimal{sign: 1, coef: 213, exp: -3}},
                 %{"My Token" => %Decimal{sign: 1, coef: 2, exp: -8}},
                 %{"NEO" => %Decimal{sign: 1, coef: 4, exp: 0}}
               ],
               time: _
             },
             %{
               assets: [
                 %{"GAS" => %Decimal{coef: 0}},
                 %{"My Token" => %Decimal{coef: 0}},
                 %{"NEO" => %Decimal{coef: 0}}
               ],
               time: _
             }
             | _
           ] = Enum.reverse(balances)
  end

  test "get/1" do
    address = insert(:address)

    assert Map.drop(address, [:__struct__, :__meta__]) ==
             Map.drop(Addresses.get(address.hash), [:__struct__, :__meta__])
  end

  test "get_split_balance/1" do
    block_time0 = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 22)

    address_history =
      insert(:address_history, %{
        asset_hash: @governing_token,
        value: Decimal.new("2.0"),
        block_time: block_time0
      })

    block_time = DateTime.from_unix!(DateTime.to_unix(DateTime.utc_now()) - 12)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @governing_token,
      value: Decimal.new("3.0"),
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: @utility_token,
      value: Decimal.new("0.2130"),
      block_time: block_time
    })

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: <<1, 2, 3>>,
      value: Decimal.new("12302.0"),
      block_time: block_time
    })

    deprecated_asset_hash = Enum.random(@deprecated_tokens)

    insert(:address_history, %{
      address_hash: address_history.address_hash,
      asset_hash: deprecated_asset_hash,
      value: Decimal.new("124.0"),
      block_time: block_time
    })

    insert(:asset, %{
      transaction_hash: @governing_token,
      type: "governing_token",
      precision: 0,
      name: [%{"lang" => "en", "name" => "NEO"}]
    })

    insert(:asset, %{
      transaction_hash: @utility_token,
      type: "utility_token",
      precision: 8,
      name: [%{"lang" => "en", "name" => "GAS"}]
    })

    insert(:asset, %{
      transaction_hash: <<1, 2, 3>>,
      precision: 25,
      symbol: "TKN",
      name: [%{"lang" => "en", "name" => "my token"}]
    })

    insert(:asset, %{
      transaction_hash: deprecated_asset_hash,
      precision: 8,
      symbol: "DPTKN",
      name: [%{"lang" => "en", "name" => "my deprecated token"}]
    })

    Flush.all()

    assert %{
             gas: %{
               asset: @utility_token,
               name: "GAS",
               precision: 8,
               symbol: nil,
               type: "utility_token",
               value: Decimal.new("0.213")
             },
             neo: %{
               asset: @governing_token,
               name: "NEO",
               precision: 0,
               symbol: nil,
               type: "governing_token",
               value: Decimal.new(5)
             },
             tokens: [
               %{
                 asset: <<1, 2, 3>>,
                 name: "my token",
                 precision: 25,
                 symbol: "TKN",
                 type: "token",
                 value: Decimal.new(12302)
               }
             ],
             deprecated_tokens: [
               %{
                 asset: deprecated_asset_hash,
                 name: "my deprecated token",
                 symbol: "DPTKN",
                 precision: 8,
                 type: "token",
                 value: Decimal.new(124)
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

    vout1_0 =
      insert(:vout, %{
        transaction_hash: transaction1.hash,
        asset_hash: @utility_token,
        value: Decimal.new("5.0")
      })

    address_hash = vout1_0.address_hash

    insert(:vout, %{
      transaction_hash: transaction1.hash,
      asset_hash: asset_hash,
      value: Decimal.new("2.0")
    })

    insert(:vout, %{
      transaction_hash: transaction1.hash,
      asset_hash: asset_hash,
      value: Decimal.new("3.0")
    })

    # normal transaction (1 vin 2 vouts) address is receiver, receive 5.0
    transaction2 = insert(:transaction)

    vout2_0 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction2.hash,
        asset_hash: asset_hash,
        value: Decimal.new("5.0")
      })

    ref_vout2_0 = insert(:vout, %{asset_hash: asset_hash, value: Decimal.new("7.0")})

    insert(:vin, %{
      transaction_hash: transaction2.hash,
      vout_n: ref_vout2_0.n,
      vout_transaction_hash: ref_vout2_0.transaction_hash
    })

    insert(:vout, %{
      transaction_hash: transaction2.hash,
      asset_hash: asset_hash,
      value: Decimal.new("2.0")
    })

    # normal transaction address is sender
    transaction3 = insert(:transaction)

    vout3_0 =
      insert(:vout, %{
        transaction_hash: transaction3.hash,
        asset_hash: asset_hash,
        value: Decimal.new("5.0")
      })

    insert(:vin, %{
      transaction_hash: transaction3.hash,
      vout_n: vout2_0.n,
      vout_transaction_hash: vout2_0.transaction_hash
    })

    # multi transaction (2 vins 1 vout)
    transaction5 = insert(:transaction)

    vout5_0 =
      insert(:vout, %{
        transaction_hash: transaction5.hash,
        asset_hash: asset_hash,
        value: Decimal.new("9.0")
      })

    transaction4 = insert(:transaction)

    vout4_0 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction4.hash,
        asset_hash: asset_hash,
        value: Decimal.new("14.0")
      })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout3_0.n,
      vout_transaction_hash: vout3_0.transaction_hash
    })

    insert(:vin, %{
      transaction_hash: transaction4.hash,
      vout_n: vout5_0.n,
      vout_transaction_hash: vout5_0.transaction_hash
    })

    # multi transaction (1 vin 2 vouts) where vin has the same address hash than 1 vout
    transaction6 = insert(:transaction)

    vout6_0 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction6.hash,
        asset_hash: asset_hash,
        value: Decimal.new("13.0")
      })

    vout6_1 =
      insert(:vout, %{
        transaction_hash: transaction6.hash,
        asset_hash: asset_hash,
        value: Decimal.new("1.0")
      })

    insert(:vin, %{
      transaction_hash: transaction6.hash,
      vout_n: vout4_0.n,
      vout_transaction_hash: vout4_0.transaction_hash
    })

    # transaction to itself
    transaction7 = insert(:transaction)

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction7.hash,
      asset_hash: asset_hash,
      value: Decimal.new("13.0")
    })

    insert(:vin, %{
      transaction_hash: transaction7.hash,
      vout_n: vout6_0.n,
      vout_transaction_hash: vout6_0.transaction_hash
    })

    # transfer transaction mint
    transaction8 = insert(:transaction)

    insert(:transfer, %{
      address_from: <<0>>,
      address_to: address_hash,
      transaction_hash: transaction8.hash,
      contract: asset_hash,
      amount: Decimal.new("18.0")
    })

    # transfer transaction burn
    transaction9 = insert(:transaction)

    insert(:transfer, %{
      address_from: address_hash,
      address_to: <<0>>,
      transaction_hash: transaction9.hash,
      contract: asset_hash,
      amount: Decimal.new("18.0")
    })

    # pay gas fee
    transaction10 = insert(:transaction)

    insert(:vin, %{
      transaction_hash: transaction10.hash,
      vout_n: vout1_0.n,
      vout_transaction_hash: vout1_0.transaction_hash
    })

    vout10_0 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction10.hash,
        asset_hash: @utility_token,
        value: Decimal.new("4.9")
      })

    transaction11 = insert(:transaction, %{type: "miner_transaction"})

    vout10_1 =
      insert(:vout, %{
        address_hash: address_hash,
        transaction_hash: transaction11.hash,
        asset_hash: @utility_token,
        value: Decimal.new("5.0")
      })

    transaction12 =
      insert(:transaction, %{type: "contract_transaction", net_fee: Decimal.new("0.2")})

    insert(:vin, %{
      transaction_hash: transaction12.hash,
      vout_n: vout10_1.n,
      vout_transaction_hash: vout10_1.transaction_hash
    })

    vout12_0 =
      insert(:vout, %{
        transaction_hash: transaction12.hash,
        asset_hash: @utility_token,
        value: Decimal.new("4.8")
      })

    transaction13 = insert(:transaction, %{type: "contract_transaction", net_fee: 0.1})

    insert(:vin, %{
      transaction_hash: transaction13.hash,
      vout_n: vout10_0.n,
      vout_transaction_hash: vout10_0.transaction_hash
    })

    insert(:vout, %{
      address_hash: address_hash,
      transaction_hash: transaction13.hash,
      asset_hash: @utility_token,
      value: 4.8
    })

    Flush.all()

    assert %{entries: entries, page_number: 1, page_size: 15, total_entries: 12, total_pages: 1} =
             Addresses.get_transaction_abstracts(address_hash, 1)

    assert entries == [
             %{
               address_from: address_hash,
               address_to: "fees",
               value: Decimal.new("0.1"),
               asset_hash: @utility_token,
               block_index: transaction13.block_index,
               block_time: transaction13.block_time,
               transaction_hash: transaction13.hash
             },
             %{
               address_from: address_hash,
               address_to: vout12_0.address_hash,
               value: Decimal.new("4.8"),
               asset_hash: @utility_token,
               block_index: transaction12.block_index,
               block_time: transaction12.block_time,
               transaction_hash: transaction12.hash
             },
             %{
               address_from: "network_fees",
               address_to: address_hash,
               value: Decimal.new(5),
               asset_hash: @utility_token,
               block_index: transaction11.block_index,
               block_time: transaction11.block_time,
               transaction_hash: transaction11.hash
             },
             %{
               address_from: address_hash,
               address_to: "fees",
               value: Decimal.new("0.1"),
               asset_hash: @utility_token,
               block_index: transaction10.block_index,
               block_time: transaction10.block_time,
               transaction_hash: transaction10.hash
             },
             %{
               address_from: address_hash,
               address_to: "burn",
               value: Decimal.new(18),
               asset_hash: asset_hash,
               block_index: transaction9.block_index,
               block_time: transaction9.block_time,
               transaction_hash: transaction9.hash
             },
             %{
               address_from: "mint",
               address_to: address_hash,
               value: Decimal.new(18),
               asset_hash: asset_hash,
               block_index: transaction8.block_index,
               block_time: transaction8.block_time,
               transaction_hash: transaction8.hash
             },
             %{
               address_from: address_hash,
               address_to: address_hash,
               value: Decimal.new(0),
               asset_hash: asset_hash,
               block_index: transaction7.block_index,
               block_time: transaction7.block_time,
               transaction_hash: transaction7.hash
             },
             %{
               address_from: address_hash,
               address_to: vout6_1.address_hash,
               value: Decimal.new(1),
               asset_hash: asset_hash,
               block_index: transaction6.block_index,
               block_time: transaction6.block_time,
               transaction_hash: transaction6.hash
             },
             %{
               address_from: "multi",
               address_to: address_hash,
               value: Decimal.new(14),
               asset_hash: asset_hash,
               block_index: transaction4.block_index,
               block_time: transaction4.block_time,
               transaction_hash: transaction4.hash
             },
             %{
               address_from: address_hash,
               address_to: vout3_0.address_hash,
               value: Decimal.new(5),
               asset_hash: asset_hash,
               block_index: transaction3.block_index,
               block_time: transaction3.block_time,
               transaction_hash: transaction3.hash
             },
             %{
               address_from: ref_vout2_0.address_hash,
               address_to: address_hash,
               value: Decimal.new(5),
               asset_hash: asset_hash,
               block_index: transaction2.block_index,
               block_time: transaction2.block_time,
               transaction_hash: transaction2.hash
             },
             %{
               address_from: "claim",
               address_to: address_hash,
               value: Decimal.new(5),
               asset_hash: @utility_token,
               block_index: transaction1.block_index,
               block_time: transaction1.block_time,
               transaction_hash: transaction1.hash
             }
           ]

    assert %{entries: entries, page_number: 1, page_size: 15, total_entries: 1, total_pages: 1} =
             Addresses.get_address_to_address_abstracts(address_hash, vout6_1.address_hash, 1)

    assert entries == [
             %{
               address_from: address_hash,
               address_to: vout6_1.address_hash,
               value: Decimal.new(1),
               asset_hash: asset_hash,
               block_index: transaction6.block_index,
               block_time: transaction6.block_time,
               transaction_hash: transaction6.hash
             }
           ]
  end
end
