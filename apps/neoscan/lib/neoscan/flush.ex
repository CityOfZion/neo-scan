defmodule Neoscan.Flush do
  alias Neoscan.Repo

  require Logger

  def address_balances do
    now = DateTime.utc_now()
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_address_balances_queue()", [], timeout: :infinity)
    diff = DateTime.diff(DateTime.utc_now(), now, :microseconds)
    Logger.info("flush_address_balances_queue: #{diff}")
  end

  def addresses do
    now = DateTime.utc_now()
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_addresses_queue()", [], timeout: :infinity)
    diff = DateTime.diff(DateTime.utc_now(), now, :microseconds)
    Logger.info("flush_addresses_queue: #{diff}")
  end

  def address_transaction_balances do
    now = DateTime.utc_now()

    Ecto.Adapters.SQL.query(Repo, "SELECT flush_address_transaction_balances_queue()", [],
      timeout: :infinity
    )

    diff = DateTime.diff(DateTime.utc_now(), now, :microseconds)
    Logger.info("flush_address_transaction_balances_queue: #{diff}")
  end

  def vouts do
    now = DateTime.utc_now()
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_vouts_queue()", [], timeout: :infinity)
    diff = DateTime.diff(DateTime.utc_now(), now, :microseconds)
    Logger.info("flush_vouts_queue: #{diff}")
  end

  def all do
    vouts()
    address_balances()
    address_transaction_balances()
    addresses()
  end
end
