defmodule Neoscan.ChainAssets do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.ChainAssets.Asset
  alias NeoscanMonitor.Api
  alias NeoscanSync.HttpCalls
  alias NeoscanSync.Blockchain

  require Logger

  @doc """
  Creates an asset.

  ## Examples

      iex> create_asset(%{field: value})
      {:ok, %Asset{}}

      iex> create_asset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_asset(transaction_id, attrs) do
    Asset.changeset(transaction_id, attrs)
    |> Repo.insert!()
    |> update_asset_state
  end
  def update_asset_state(asset) do
    Api.add_asset(asset)
    asset
  end

  @doc """
  Gets asset  by its hash value

  ## Examples

      iex> get_asset_by_hash(hash)
      "NEO"

      iex> get_asset_by_hash(hash)
      "not found"

  """
  def get_asset_by_hash(hash) do
    query = from e in Asset,
                 where: e.txid == ^hash
    Repo.all(query)
    |> List.first
  end

  @doc """
  Gets asset name by its hash value

  ## Examples

      iex> get_asset_name_by_hash(hash)
      "NEO"

      iex> get_asset_name_by_hash(hash)
      "not found"

  """
  def get_asset_name_by_hash(hash) do
    query = from e in Asset,
                 where: e.txid == ^hash,
                 select: e.name
    Repo.all(query)
    |> List.first
    |> filter_name
  end

  def filter_name(nil) do
    "Asset not Found"
  end
  def filter_name(asset) do
    case Enum.find(asset, fn %{"lang" => lang} -> lang == "en" end) do
      %{"name" => name} -> cond do
                             name == "AntShare" ->
                               "NEO"
                             name == "AntCoin" ->
                               "GAS"
                             true ->
                               name
                           end
      nil ->
        %{"name" => name} = Enum.at(asset, 0)
        name
    end
  end

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def list_assets do
    query = from e in Asset,
                 select: %{
                   :txid => e.txid,
                   :admin => e.admin,
                   :amount => e.amount,
                   :issued => e.issued,
                   :type => e.type,
                   :time => e.time,
                   :name => e.name,
                   :owner => e.owner,
                   :precision => e.precision
                 }
    Repo.all(query)
  end

  @doc """
  Updates an asset.

  ## Examples

      iex> update_asset(asset, %{field: new_value})
      {:ok, %Asset{}}

      iex> update_asset(asset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_asset(%Asset{} = asset, attrs) do
    asset
    |> Asset.update_changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Add issued value to an existing asset
  """
  def add_issued_value(asset_hash, value) do
    result = get_asset_by_hash(asset_hash)
    if result == nil do
      Logger.error("Error issuing asset")
      {:error, "Non existant asset cant be issued!"}
    else
      attrs = %{"issued" => value}
      update_asset(result, attrs)
    end
  end

  @doc """
  Create new assets
  """
  #create new assets
  def create(%{"amount" => amount} = asset, txid, time) do
    {float, _} = Float.parse(amount)
    new_asset = Map.merge(asset, %{"amount" => float, "time" => time})
    create_asset(txid, new_asset)
  end
  def create(nil, _txid, _time) do
    nil
  end

  @doc """
  Issue assets
  """
  def issue("IssueTransaction", vouts) do
    Enum.each(
      vouts,
      fn %{"asset" => asset_hash, "value" => value} ->
        {float, _} = Float.parse(value)
        add_issued_value(String.slice(to_string(asset_hash), -64..-1), float)
      end
    )
  end
  def issue(_type, _vouts) do
    nil
  end

  def verify_asset(hash, time) do
    case Api.check_asset(hash) do
      true ->
        hash
      false ->
        get_new_asset(hash, time)
        |> Map.get(:txid)
    end
  end

  def get_new_asset(hash, time) do
    asset = Blockchain.get_asset(HttpCalls.url, hash)

    case asset do
      {:ok, result} ->
        create(result, hash, time)
      _ ->
        get_new_asset(hash, time)
    end
  end

end
