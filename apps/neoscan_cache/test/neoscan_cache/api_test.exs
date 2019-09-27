defmodule NeoscanCache.ApiTest do
  use NeoscanCache.DataCase
  import NeoscanCache.Factory

  alias NeoscanCache.Api
  alias NeoscanCache.DbPoller

  test "get_blocks/0" do
    assert is_list(Api.get_blocks())
  end

  test "get_transactions/0" do
    asset = insert(:asset)
    transaction = insert(:transaction, %{type: "contract_transaction"})

    insert(:vout, %{
      transaction_id: transaction.id,
      transaction_hash: transaction.hash,
      asset_hash: asset.transaction_hash
    })

    insert(:transaction, %{type: "contract_transaction"})
    DbPoller.do_poll()
    assert [_, %{vouts: [_]}] = Api.get_transactions()
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
