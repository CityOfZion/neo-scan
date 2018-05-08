defmodule NeoscanMonitor.Utils do
  @moduledoc false
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.Stats
  alias Neoscan.ChainAssets
  alias NeoscanNode.Notifications
  alias NeoscanNode.Blockchain

  # blockchain api nodes
  def seeds do
    Application.fetch_env!(:neoscan_monitor, :seeds)
  end

  # function to load nodes state
  def load do
    data =
      seeds()
      |> pmap(fn url ->
        current_height = Blockchain.get_current_height(url)
        {url, current_height, evaluate_result(url, current_height)}
      end)
      |> Enum.filter(fn {_, _, keep} -> keep end)
      |> Enum.map(fn {url, {:ok, height}, _} -> {url, height} end)

    set_state(data)
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1, 15_000))
  end

  # handler for nil data
  defp set_state([] = data) do
    %{:nodes => [], :height => {:ok, nil}, :data => data}
  end

  # call filters on results and set state
  defp set_state(data) do
    height = filter_height(data)
    %{nodes: filter_nodes(data, height), height: {:ok, height}, data: data}
  end

  # filter working nodes
  defp filter_nodes(data, height) do
    data
    |> Enum.filter(fn {_url, hgt} -> hgt == height end)
    |> Enum.map(fn {url, _height} -> url end)
  end

  # filter current height
  defp filter_height(data) do
    {height, _count} =
      data
      |> Enum.map(fn {_url, height} -> height end)
      |> Enum.reduce(%{}, fn height, acc ->
        Map.update(acc, height, 1, &(&1 + 1))
      end)
      |> Enum.max_by(fn {_height, count} -> count end)

    height
  end

  # handler to filter errors
  defp evaluate_result(url, {:ok, height}) do
    test_get_block(url, height)
  end

  defp evaluate_result(_url, {:error, _height}) do
    false
  end

  # test node api
  defp test_get_block(url, height) do
    Blockchain.get_block_by_height(url, height - 1)
    |> test()
  end

  # handler to test response
  defp test({:ok, _block}) do
    true
  end

  defp test({:error, _reason}) do
    false
  end

  # function to cut extra elements
  def cut_if_more(list, count) when count == 15 do
    list
    |> Enum.drop(-1)
  end

  def cut_if_more(list, _count) do
    list
  end

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
