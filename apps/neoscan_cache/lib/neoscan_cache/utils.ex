defmodule NeoscanCache.Utils do
  @moduledoc false
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.Stats
  alias Neoscan.ChainAssets
  alias NeoscanNode.Notifications

  # function to get DB asset stats
  def get_stats(assets) do
    Enum.map(assets, fn asset ->
      cond do
        asset.contract == nil ->
          Map.put(asset, :stats, %{
            :addresses => Addresses.count_addresses_for_asset(asset.txid),
            :transactions => Stats.count_transactions_for_asset(asset.txid)
          })

        asset.contract != nil ->
          Map.put(asset, :stats, %{
            :addresses => Addresses.count_addresses_for_asset(asset.contract),
            :transactions => Stats.count_transactions_for_asset(asset.contract)
          })
      end
    end)
  end

  # function to get general db stats
  def get_general_stats do
    %{
      :total_blocks => Stats.count_blocks(),
      :total_transactions => Stats.count_transactions(),
      :total_transfers => Stats.count_transfers(),
      :total_addresses => Stats.count_addresses()
    }
  end

  # function to add vouts to transactions
  def add_vouts(transactions) do
    ids = Enum.map(transactions, fn tx -> tx.id end)
    vouts = Transactions.get_transactions_vouts(ids)

    transactions
    |> Enum.map(fn tx ->
      Map.put(
        tx,
        :vouts,
        Enum.filter(vouts, fn vout ->
          vout.transaction_id == tx.id
        end)
      )
    end)
  end

  def add_new_tokens(old_list \\ []) do
    Enum.filter(get_token_notifications(), fn %{"token" => token} ->
      Enum.all?(old_list, fn %{"token" => old_token} ->
        token["script_hash"] != old_token["script_hash"]
      end)
    end)
    |> ChainAssets.create_tokens()
  end

  defp get_token_notifications do
    case Notifications.get_token_notifications() do
      {:error, _} ->
        get_token_notifications()

      result ->
        result
    end
  end
end
