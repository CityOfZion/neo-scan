defmodule Neoscan.Assets do
  @moduledoc false

  alias Neoscan.Asset
  import Ecto.Query
  alias Neoscan.Repo

  #  @doc """
  #  Gets asset  by its hash value
  #
  #  ## Examples
  #
  #      iex> get_asset_by_hash(hash)
  #      "NEO"
  #
  #      iex> get_asset_by_hash(hash)
  #      "not found"
  #
  #  """
  #  def get_asset_by_hash(hash) do
  #    query = from(e in Asset, where: e.txid == ^hash)
  #
  #    Repo.all(query)
  #    |> List.first()
  #  end
  #
  #  @doc """
  #  Gets token  by its contract value
  #
  #  ## Examples
  #
  #      iex> get_token_by_contract(hash)
  #      "NEO"
  #
  #      iex> get_token_by_contract(hash)
  #      "not found"
  #
  #  """
  #  def get_token_by_contract(hash) do
  #    query = from(e in Asset, where: e.contract == ^hash)
  #
  #    Repo.all(query)
  #    |> List.first()
  #  end
  #
  #  @doc """
  #  Gets asset name by its hash value
  #
  #  ## Examples
  #
  #      iex> get_asset_name_by_hash(hash)
  #      "NEO"
  #
  #      iex> get_asset_name_by_hash(hash)
  #      "not found"
  #
  #  """
  #  def get_asset_name_by_hash(hash) do
  #    query =
  #      if String.length(hash) > 40 do
  #        from(e in Asset, where: e.txid == ^hash, select: e.name)
  #      else
  #        from(e in Asset, where: e.contract == ^hash, select: e.name)
  #      end
  #
  #    Repo.all(query)
  #    |> List.first()
  #    |> filter_name
  #  end

  @doc """
  Gets asset precision by its hash value

  ## Examples

      iex> get_asset_precision_by_hash(hash)
      8

      iex> get_asset_precision_by_hash(bad_hash)
      nil

  """
  def get_asset_precision_by_hash(_hash) do
    8
    #    query =
    #      if String.length(hash) == 40 do
    #        from(e in Asset, where: e.contract == ^hash, select: e.precision)
    #      else
    #        from(e in Asset, where: e.txid == ^hash, select: e.precision)
    #      end
    #
    #    Repo.all(query)
    #    |> List.first()
  end

  @doc """
  Returns the list of assets.

  ## Examples

      iex> list_assets()
      [%Asset{}, ...]

  """
  def get_all do
    Repo.all(from(e in Asset))
  end
end
