defmodule NeoscanCache.ApiTest do
  use NeoscanCache.DataCase
  import NeoscanCache.Factory

  alias NeoscanCache.Api
  alias NeoscanCache.Cache

  test "get_blocks/0" do
    assert is_list(Api.get_blocks())
  end

  test "get_transactions/0" do
    transaction = insert(:transaction, %{type: "contract_transaction"})
    insert(:vout, %{transaction_hash: transaction.hash})
    insert(:transaction, %{type: "contract_transaction"})
    Cache.sync()
    assert [_, %{vouts: [_]}] = Api.get_transactions()
  end

  test "get_assets/0" do
    insert(:asset)
    insert(:asset)
    Cache.sync()
    assert is_list(Api.get_assets())
  end

  test "get_asset_name/1" do
    asset = insert(:asset)
    Cache.sync()
    assert "truc" == Api.get_asset_name(asset.transaction_hash)
    assert "Asset not Found" == Api.get_asset_name("1234567890123456789012345678901234567890")
  end

  test "get_asset_precision/1" do
    asset = insert(:asset)
    Cache.sync()
    assert asset.precision == Api.get_asset_precision(asset.transaction_hash)
  end

  test "get_addresses/0" do
    assert is_list(Api.get_addresses())
  end

  test "get_price/0" do
    assert %{
             gas: %{
               btc: %{},
               usd: %{}
             },
             neo: %{
               btc: %{},
               usd: %{}
             }
           } = Api.get_price()
  end

  test "get_stats/0" do
    assert %{
             total_addresses: _,
             total_blocks: _,
             total_transactions: [_ | _],
             total_transfers: _
           } = Api.get_stats()
  end
end
