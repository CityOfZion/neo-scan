defmodule Neoscan.Flush do
  alias Neoscan.Repo

  def address_balances do
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_balances_queue()", [])
  end

  def addresses do
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_addresses_queue()", [])
  end

  def address_transaction_balances do
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_address_transaction_balances_queue()", [])
  end

  def vouts do
    Ecto.Adapters.SQL.query!(Repo, "SELECT flush_vouts_queue()", [])
  end

  def all do
    address_balances()
    addresses()
    address_transaction_balances()
    vouts()
  end
end
