defmodule Neoscan.Stats do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Stats.Counter
  alias Neoscan.Repo
  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Addresses
  alias Neoscan.ChainAssets

  require Logger

  @doc """
  Creates an stats.

  ## Examples

      iex> create_stats(%{field: value})
      {:ok, %stats{}}

      iex> create_stats(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def initialize_counter() do
    %{
      :total_blocks => Blocks.count_blocks(),
      :total_transactions=> Transactions.count_transactions(),
      :total_addresses => Addresses.count_addresses(),
      :contract_transactions => Transactions.count_transactions(['ContractTransaction']),
      :invocation_transactions => Transactions.count_transactions(['InvocationTransaction']),
      :miner_transactions => Transactions.count_transactions(['MinerTransaction']),
      :publish_transactions => Transactions.count_transactions(['PublishTransaction']),
      :issue_transactions => Transactions.count_transactions(['IssueTransaction']),
      :register_transactions => Transactions.count_transactions(['RegisterTransaction']),
    }
    |> Map.merge(ChainAssets.get_assets_stats())
    |> Counter.changeset()
    |> Repo.insert!()
  end


  @doc """
  Updates an stats.

  ## Examples

      iex> update_stats(stats, %{field: new_value})
      {:ok, %stats{}}

      iex> update_stats(stats, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_counter(%Counter{} = counter, attrs) do
    counter
    |> Counter.update_changeset(attrs)
    |> Repo.update!()
  end

  def get_counter do
    Repo.all(Counter)
    |> List.first()
    |> create_if_doesnt_exists()
  end

  def create_if_doesnt_exists(nil) do
    initialize_counter()
  end
  def create_if_doesnt_exists(counter) do
    counter
  end

end
