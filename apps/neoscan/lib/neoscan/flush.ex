defmodule Neoscan.Flush do
  alias Neoscan.Repo

  require Logger

  def address_balances do
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_address_balances_queue()", [], timeout: :infinity)
  end

  def addresses do
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_addresses_queue()", [], timeout: :infinity)
  end

  def address_transaction_balances do
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_address_transaction_balances_queue()", [],
      timeout: :infinity
    )
  end

  def vouts do
    Ecto.Adapters.SQL.query(Repo, "SELECT flush_vouts_queue()", [], timeout: :infinity)
  end

  def all do
    vouts()
    address_balances()
    address_transaction_balances()
    addresses()
  end
end
