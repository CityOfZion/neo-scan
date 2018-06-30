defmodule Neoscan.Repo.Migrations.AddressTransactionBalances do
  use Ecto.Migration

  def change do
    create table(:address_transaction_balances, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:transaction_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
      add(:value, :float, null: false)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    create(index(:address_transaction_balances, [:address_hash, :block_time]))
    create(index(:address_transaction_balances, [:transaction_hash]))
    create(index(:address_transaction_balances, [:transaction_hash, :asset_hash]))
  end
end
