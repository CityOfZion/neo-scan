defmodule NeoscanCache.ApiTest do
  use NeoscanCache.DataCase
  import NeoscanCache.Factory

  alias NeoscanCache.Api
  alias NeoscanCache.Cache

  test "get_blocks/0" do
    assert is_list(Api.get_blocks())
  end

  test "get_transactions/0" do
    transaction = insert(:transaction)
    insert(:vout, %{transaction_hash: transaction.hash})
    insert(:transaction)
    Cache.sync()
    assert [_, %{vouts: [_]}] = Api.get_transactions()
  end

  test "get_assets/0" do
    insert(:asset)
    insert(:asset)
    Cache.sync()
    assert is_list(Api.get_assets())
  end

  #  test "get_asset/1" do
  #    Cache.sync(%{tokens: []})
  #
  #    assert %{type: "token"} =
  #             Api.get_asset("e708a3e7697d89b9d3775399dcee22ffffed9602c4077968a66e059a4cccbe25")
  #  end

  test "get_asset_name/0" do
    assert "Asset not Found" == Api.get_asset_name("21he9812")
    assert "Asset not Found" == Api.get_asset_name("1234567890123456789012345678901234567890")
  end

  #  test "check_asset/1" do
  #    assert not Api.check_asset("random")
  #  end

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
