defmodule NeoscanWeb.ApiController do
  use NeoscanWeb, :controller

  alias Neoscan.Api

  def get_balance(conn, %{"hash" => hash}) do
    balance = Api.get_balance(hash)
    json(conn, balance)
  end

  def get_claimed(conn, %{"hash" => hash}) do
    claimed = Api.get_claimed(hash)
    json(conn, claimed)
  end

  def get_unclaimed(conn, %{"hash" => hash}) do
    unclaimed = Api.get_unclaimed(hash)
    json(conn, unclaimed)
  end

  def get_claimable(conn, %{"hash" => hash}) do
    claimable = Api.get_claimable(hash)
    json(conn, claimable)
  end

  def get_address(conn, %{"hash" => hash}) do
    address = Api.get_address(hash)
    json(conn, address)
  end

  def get_address_neon(conn, %{"hash" => hash}) do
    address = Api.get_address_neon(hash)
    json(conn, address)
  end

  def get_assets(conn, _params) do
    assets = Api.get_assets()
    json(conn, assets)
  end

  def get_asset(conn, %{"hash" => hash}) do
    asset = Api.get_asset(hash)
    json(conn, asset)
  end

  def get_block(conn, %{"hash" => hash}) do
    block = Api.get_block(hash)
    json(conn, block)
  end

  def get_last_blocks(conn, _params) do
    blocks = Api.get_last_blocks()
    json(conn, blocks)
  end

  def get_highest_block(conn, _params) do
    block = Api.get_highest_block()
    json(conn, block)
  end

  def get_transaction(conn, %{"hash" => hash}) do
    transaction = Api.get_transaction(hash)
    json(conn, transaction)
  end

  def get_last_transactions(conn, %{"type" => type}) do
    transactions = Api.get_last_transactions(type)
    json(conn, transactions)
  end

  def get_last_transactions(conn, %{}) do
    transactions = Api.get_last_transactions(nil)
    json(conn, transactions)
  end

  def get_last_transactions_by_address(conn, %{"hash" => hash}) do
    transactions = Api.get_last_transactions_by_address(hash, 1)
    json(conn, transactions)
  end

  def get_last_transactions_by_address(conn, %{"hash" => hash, "page" => page}) do
    transactions = Api.get_last_transactions_by_address(hash, page)
    json(conn, transactions)
  end

  def get_all_nodes(conn, %{}) do
    nodes = Api.get_all_nodes()
    json(conn, nodes)
  end

  def get_nodes(conn, %{}) do
    nodes = Api.get_nodes()
    json(conn, nodes)
  end

  def get_height(conn, %{}) do
    height = Api.get_height()
    json(conn, height)
  end

  def get_fees_in_range(conn, %{"range" => range}) do
    fees = Api.get_fees_in_range(range)
    json(conn, fees)
  end

  def repair_blocks(conn, %{}) do
    result = Api.repair_blocks()
    json(conn, result)
  end

  def repair_block_counter(conn, %{}) do
    result = Api.repair_block_counter()
    json(conn, result)
  end
end
